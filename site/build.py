#!/usr/bin/env python3
"""Build the examples website into docs/ for GitHub Pages.

Each example is laid out like Go by Example: the comments in main.exs become the prose
on the left, the code they describe sits on the right, and the commands from the
header's Run: lines are executed so the page shows their real output.

Usage: python3 site/build.py            # runs every example and writes docs/
       python3 site/build.py --no-run   # skips running, for quick layout work
       python3 -m http.server -d docs   # preview at http://localhost:8000
"""

import html
import os
import re
import shutil
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SITE = ROOT / "site"
OUT = ROOT / "docs"
REPO = ""

PARTS = [
    ("Basics", 1, 8),
    ("Collections", 9, 13),
    ("Functions", 14, 19),
    ("Control flow", 20, 23),
    ("Enumerables", 24, 25),
    ("Data", 26, 32),
    ("Standard library", 33, 37),
    ("Processes", 38, 43),
    ("Errors and tests", 44, 45),
    ("Modules and tests", 46, 48),
    ("OTP", 49, 53),
    ("Data and language", 54, 59),
    ("BEAM", 60, 70),
    ("Ecosystem", 71, 75),
]

# Examples that read arguments do not make sense pasted into the playground.
NO_PLAYGROUND = {
    "37_environment",
    "58_mix",
    "65_genstage",
    "66_broadway",
    "67_distribution",
    "69_nif",
    "70_releases",
    "71_telemetry",
    "72_dialyzer",
    "73_ecto",
    "74_phoenix",
    "75_liveview",
}

DOC_LINE = re.compile(r"^\s*#(?!!)( ?)(.*)$")
NOTE_LINE = re.compile(r"^\s*# (error|vet): ")


# ---------------------------------------------------------------------------
# Go highlighting

KEYWORDS = set(
    """
    after alias and case catch cond def defp defdelegate defexception defguard defguardp defimpl defmacro
    defmacrop defmodule defoverridable defprotocol defstruct do else end fn for if import
    in not or quote raise receive require rescue super then try unless unquote
    unquote_splicing use when with
    """.split()
)

BUILTINS = set(
    """
    abs apply binary_part bit_size byte_size div elem exit hd inspect is_atom is_binary
    is_boolean is_float is_function is_integer is_list is_map is_nil is_number is_pid
    is_tuple length make_ref map_size max min node rem round self send spawn throw tl
    trunc tuple_size
    """.split()
)

CONSTANTS = {"true", "false", "nil"}

TOKEN = re.compile(
    r"""
    (?P<comment>\#[^\n]*)
    |(?P<sigil>~[A-Za-z](?:\([^)\n]*\)|\[[^\]\n]*\]|\{[^}\n]*\}|/[^\n/]*/|"[^"\n]*")[a-z]*)
    |(?P<str>"(?:\\.|[^"\\\n])*")
    |(?P<atom>:(?:[A-Za-z_]\w*[!?]?)?)
    |(?P<num>\b(?:0[xX][0-9A-Fa-f_]+|0[bB][01_]+|0[oO][0-7_]+|\d[\d_]*(?:\.\d[\d_]*)?(?:[eE][+-]?\d+)?)\b)
    |(?P<ident>\b[A-Za-z_]\w*[!?]?)
    |(?P<attr>@[A-Za-z_]\w*)
    """,
    re.VERBOSE,
)

NOTE_COMMENT = re.compile(r"\#\s*(error|vet):")


def highlight(code):
    out = []
    pos = 0
    prev = None
    for m in TOKEN.finditer(code):
        out.append(html.escape(code[pos : m.start()]))
        text = m.group()
        kind = m.lastgroup
        cls = None
        if kind == "comment":
            cls = "e" if NOTE_COMMENT.match(text) else "c"
        elif kind in ("sigil", "str"):
            cls = "s"
        elif kind == "atom":
            cls = "n"
        elif kind == "num":
            cls = "n"
        elif kind == "attr":
            cls = "a"
        elif kind == "ident":
            after = code[m.end() : m.end() + 1]
            if text in KEYWORDS:
                cls = "k"
            elif text in CONSTANTS:
                cls = "n"
            elif text[:1].isupper():
                cls = "t"
            elif text in BUILTINS and after == "(":
                cls = "m"
            elif after == "(" and prev in ("def", "defp", "defmacro"):
                cls = "f"

            prev = text

        esc = html.escape(text)
        out.append(f'<span class="{cls}">{esc}</span>' if cls else esc)
        pos = m.end()

    out.append(html.escape(code[pos:]))
    return "".join(out)


# ---------------------------------------------------------------------------
# Prose

LEAD = "(\"“"
TRAIL = ".,;:\"”)"
PROSE_ABBREVIATIONS = {"e.g.", "i.e.", "etc.", "vs.", "e.g", "i.e", "vs"}
ELIXIR_WORDS = {"nil", "true", "false", "_", "&", "...", "|", "|>", "%{}"}


def looks_like_code(word):
    if word in PROSE_ABBREVIATIONS:
        return False

    if word in ELIXIR_WORDS or word.startswith(":"):
        return True

    if re.search(r"\|>|::|<-|->|\(\)|\[\]|[{}]|%[A-Za-z{]|^#|^-\w|^\$|=\w|\w=|\w\(|\w\[|\w\*", word):
        return True

    # Package-qualified names and method calls: fmt.Println, ctx.Done, os.Args.
    if re.fullmatch(r"[a-z]\w*(\.[A-Za-z_]\w*)+[\w.()\[\]:]*", word):
        return True

    # Package paths and files: encoding/json, main_test.go, go.mod.
    if re.fullmatch(r"[\w.-]+\.(ex|exs|txt)", word):
        return True

    # Identifiers that cannot be English words: camelCase, CamelCase, snake_case.
    if re.fullmatch(r"[a-z]+[A-Z]\w*|[A-Z][a-z0-9]+(?:[A-Z][a-z0-9]*)+|\w+_\w+|\*?[A-Z][A-Za-z]*\.[A-Z]\w*", word):
        return True

    return bool(re.fullmatch(r"[*&]\w+|\w+\.\.\.|\.\.\.\w+", word))


def split_punct(word):
    lead = ""
    while word and word[0] in LEAD:
        lead += word[0]
        word = word[1:]

    trail = ""
    while len(word) > 1 and word[-1] in TRAIL and not word.endswith("()") and not word.endswith("..."):
        if word[-1] == ")" and word.count("(") >= word.count(")"):
            break
        trail = word[-1] + trail
        word = word[:-1]

    return lead, word, trail


def unbalanced(code):
    pairs = ("()", "[]", "{}")
    return any(code.count(a) > code.count(b) for a, b in pairs) or code.count('"') % 2 == 1


def inline(text):
    """Escape prose, wrapping code-looking words (and runs of them) in <code>."""
    pieces = []
    run = []
    run_glued = False

    def flush():
        if run:
            pieces.append(("<code>" + html.escape(" ".join(run)) + "</code>", run_glued))
            run.clear()

    for word in text.split():
        # Inside an open bracket or quote, every word belongs to the code span.
        if run and unbalanced(" ".join(run)):
            core = word.rstrip(".,;:")
            run.append(core)
            if core != word and not unbalanced(" ".join(run)):
                flush()
                pieces.append((html.escape(word[len(core):]), True))
            continue

        lead, core, trail = split_punct(word)
        if core and looks_like_code(core):
            if lead:
                flush()
                pieces.append((html.escape(lead), False))

            if not run:
                run_glued = bool(lead)

            run.append(core)
            if trail and unbalanced(" ".join(run)):
                run[-1] += trail
            elif trail:
                flush()
                pieces.append((html.escape(trail), True))
        else:
            flush()
            pieces.append((html.escape(word), False))

    flush()
    out = ""
    for piece, glued in pieces:
        out += piece if glued or not out else " " + piece

    return out


def prose(lines):
    """Turn comment lines into <p> blocks; blank comment lines separate paragraphs."""
    blocks = []
    para = []
    for line in lines + [""]:
        if line.strip():
            para.append(line.strip())
        elif para:
            blocks.append("<p>" + inline(" ".join(para)) + "</p>")
            para = []

    return "\n".join(blocks)


# ---------------------------------------------------------------------------
# Example parsing


def segments(lines):
    """Split source lines into (doc lines, code lines) pairs, Go by Example style."""
    segs = []
    docs, code = [], []
    i = 0
    while i < len(lines):
        line = lines[i]
        is_doc = DOC_LINE.match(line) and not NOTE_LINE.match(line)

        # Commented-out code followed by an error note is code, not prose.
        if is_doc and i + 1 < len(lines) and NOTE_LINE.match(lines[i + 1]):
            is_doc = False

        if is_doc:
            if code:
                segs.append((docs, code))
                docs, code = [], []
            docs.append(DOC_LINE.match(line).group(2))
        elif line.strip() or code:
            code.append(line)
        i += 1

    segs.append((docs, code))

    out = []
    for d, c in segs:
        while c and not c[-1].strip():
            c.pop()
        if d or c:
            out.append((prose(d), "\n".join(c)))

    return out


def parse(folder):
    text = (folder / "main.exs").read_text()
    lines = text.splitlines()

    header = []
    i = 0
    while lines[i].startswith("#"):
        header.append(lines[i][2:] if lines[i].startswith("# ") else lines[i][1:])
        i += 1

    title = header[0].strip()
    command = re.compile(r"^(?:Run): (.*)")
    commands = [command.match(l).group(1) for l in header if command.match(l)]
    body = [l for l in header[1:] if not command.match(l)]

    extras = []
    skip_dirs = {"_build", "deps"}
    skip_suffixes = {".so", ".o", ".beam", ".ez"}
    for p in sorted(folder.rglob("*")):
        rel_path = p.relative_to(folder)
        if not p.is_file() or p.name == "main.exs":
            continue
        if any(part in skip_dirs for part in rel_path.parts) or p.suffix in skip_suffixes:
            continue
        rel = rel_path.as_posix()
        src = p.read_text().rstrip()
        segs = segments(src.splitlines()) if p.suffix in (".ex", ".exs") else None
        extras.append({"name": rel, "source": src, "segments": segs})

    stdlib = {
        "Access", "Agent", "Application", "Code", "Date", "DateTime", "DynamicSupervisor",
        "Enum", "Exception", "File", "GenServer", "IO", "JSON", "Keyword", "Logger", "Map",
        "MapSet", "Path", "Port", "Process", "Regex", "Registry", "Stream", "String",
        "Supervisor", "System", "Task", "Time", "URI",
    }
    imports = {name for name in re.findall(r"\b([A-Z][A-Za-z0-9]*)\b", text) if name in stdlib}

    return {
        "slug": folder.name,
        "num": int(folder.name[:2]),
        "title": title,
        "intro": prose(body),
        "commands": commands,
        "segments": segments(lines[i:]),
        "source": text.rstrip(),
        "extras": extras,
        "imports": imports,
        "lines": text.count("\n") + 1,
    }


# ---------------------------------------------------------------------------
# Running examples for their output


def scrub(text):
    text = text.replace(str(ROOT), ".")
    text = text.replace(str(Path.home()), "~")
    text = re.sub(r"/private/var/folders/[^\s\"']+?/T\b", "/tmp", text)
    return text.replace(tempfile.gettempdir().rstrip("/"), "/tmp")


def run_example(example):
    shell = []
    for cmd in example["commands"]:
        try:
            proc = subprocess.run(
                ["bash", "-c", cmd],
                cwd=ROOT,
                stdin=subprocess.DEVNULL,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                timeout=300 if "dialyzer" not in cmd and "release" not in cmd else 900,
                text=True,
                env={k: v for k, v in os.environ.items() if k not in ("FOO", "BAR")},
            )
            output = scrub(proc.stdout).rstrip()
        except subprocess.TimeoutExpired:
            print(f"  {example['slug']}: {cmd!r} timed out", file=sys.stderr)
            output = ""

        shell.append((cmd, output))

    example["shell"] = shell


def run_outputs(examples):
    # Independent examples run side by side; commands within one stay in order.
    with ThreadPoolExecutor(max_workers=4) as pool:
        list(pool.map(run_example, examples))


# ---------------------------------------------------------------------------
# Pages

FONTS = (
    "https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,400..700"
    "&family=JetBrains+Mono:wght@400;500&display=swap"
)

FAVICON = (
    "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'>"
    "<rect width='32' height='32' rx='8' fill='%231C1B19'/><text x='16' y='22' "
    "font-family='Arial' font-weight='700' font-size='17' fill='white' "
    "text-anchor='middle'>R</text></svg>"
)

THEME_BOOT = (
    "(function(){try{var t=localStorage.getItem('_ftheme');"
    "if(!t&&matchMedia('(prefers-color-scheme: dark)').matches)t='dark';"
    "if(t&&t!=='default')document.documentElement.classList.add('theme-'+t)}catch(e){}})();"
)

ICON_COPY = (
    '<svg viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="1.5">'
    '<rect x="7" y="7" width="10" height="10" rx="2"/>'
    '<path d="M13 7V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h2"/></svg>'
)
ICON_PLAY = '<svg viewBox="0 0 20 20" fill="currentColor"><path d="M6 4.5v11l9-5.5z"/></svg>'
ICON_GITHUB = (
    '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M8 0C3.58 0 0 3.58 0 8c0 '
    "3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49"
    "-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82."
    "72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-"
    "1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 "
    "1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 "
    "2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21."
    '15.46.55.38A8.013 8.013 0 0 0 16 8c0-4.42-3.58-8-8-8z"/></svg>'
)


def page(title, body, base, description):
    return f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{html.escape(title)}</title>
<meta name="description" content="{html.escape(description)}">
<link rel="icon" href="{FAVICON}">
<script>{THEME_BOOT}</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="{FONTS}">
<link rel="stylesheet" href="{base}assets/style.css">
</head>
<body>
<header class="topbar">
  <button class="menu-btn" type="button" aria-label="Examples" data-menu>
    <svg viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M3 6h14M3 10h14M3 14h14"/></svg>
  </button>
  <a class="brand" href="{base}"><span class="brand-mark">R</span>Rune</a>
  <nav class="topnav">
    <a class="nav-link" href="{base}">Examples</a>
    {f'<a class="nav-link" href="{REPO}" aria-label="GitHub">{ICON_GITHUB}<span>GitHub</span></a>' if REPO else ''}
    <select class="input-field theme-select" aria-label="Theme" data-theme-select>
      <option value="default">Default</option>
      <option value="blue">Blue</option>
      <option value="slate">Slate</option>
      <option value="emerald">Emerald</option>
      <option value="dark">Dark</option>
    </select>
  </nav>
</header>
{body}
<script src="{base}assets/site.js"></script>
</body>
</html>
"""


def copy_button(text=None):
    attr = f'data-copy-text="{html.escape(text)}"' if text is not None else "data-copy"
    return f'<button class="icon-btn" type="button" {attr} title="Copy">{ICON_COPY}</button>'


def segment_table(segs, source, extra_buttons=""):
    rows = []
    for i, (doc, code) in enumerate(segs):
        actions = ""
        if i == 0:
            actions = f'<div class="code-actions">{extra_buttons}{copy_button(source)}</div>'

        code_html = f"<pre><code>{highlight(code)}</code></pre>" if code else ""
        empty = "" if code else " empty"
        rows.append(
            f'<div class="seg"><div class="seg-doc prose">{doc}</div>'
            f'<div class="seg-code code{empty}">{actions}{code_html}</div></div>'
        )

    return f'<div class="segs">{"".join(rows)}</div>'


def shell_block(shell):
    parts = []
    for cmd, output in shell:
        parts.append(f'<span class="prompt">$</span> <span class="cmd">{html.escape(cmd)}</span>')
        if output:
            parts.append(html.escape(output))

    return '<div class="shell"><pre>' + "\n".join(parts) + "</pre></div>"


def sidebar(examples, active, base):
    out = [
        '<aside class="sidebar" data-sidebar>',
        '<input class="input-field side-search" type="search" placeholder="Filter examples  /" data-filter>',
    ]
    for name, lo, hi in PARTS:
        links = []
        for e in examples:
            if lo <= e["num"] <= hi:
                cls = "side-link active" if e["slug"] == active else "side-link"
                links.append(
                    f'<a class="{cls}" href="{base}{e["slug"]}/">'
                    f'<span class="side-num">{e["num"]:02}</span>'
                    f'<span>{html.escape(e["title"])}</span></a>'
                )

        out.append(
            f'<div class="side-part"><div class="side-title">{html.escape(name)}</div>'
            + "".join(links)
            + "</div>"
        )

    out.append("</aside>")
    return "\n".join(out)


def part_of(num):
    return next(name for name, lo, hi in PARTS if lo <= num <= hi)


def example_page(ex, prev, nxt, examples):
    base = "../"
    slug = ex["slug"]

    play = ""
    if slug not in NO_PLAYGROUND and not any(e["name"].endswith((".ex", ".exs")) or "/" in e["name"] for e in ex["extras"]):
        play = (
            '<button class="icon-btn" type="button" data-play title="Copy and open an Elixir playground">'
            f"{ICON_PLAY}</button>"
        )

    body_parts = [segment_table(ex["segments"], ex["source"], play)]
    if ex.get("shell"):
        body_parts.append(shell_block(ex["shell"]))

    for extra in ex["extras"]:
        body_parts.append(f'<h3 class="file-name">{html.escape(slug + "/" + extra["name"])}</h3>')
        if extra["segments"]:
            body_parts.append(segment_table(extra["segments"], extra["source"]))
        else:
            body_parts.append(
                '<div class="segs"><div class="seg"><div class="seg-doc"></div>'
                f'<div class="seg-code code"><div class="code-actions">{copy_button(extra["source"])}</div>'
                f'<pre><code>{html.escape(extra["source"])}</code></pre></div></div></div>'
            )

    pager = ['<nav class="pager">']
    if prev:
        pager.append(
            f'<a class="pager-card" href="{base}{prev["slug"]}/" data-prev>'
            f'<span class="pager-dir">← Previous</span>'
            f'<span class="pager-title">{prev["num"]:02}. {html.escape(prev["title"])}</span></a>'
        )
    else:
        pager.append("<span></span>")

    if nxt:
        pager.append(
            f'<a class="pager-card next" href="{base}{nxt["slug"]}/" data-next>'
            f'<span class="pager-dir">Next →</span>'
            f'<span class="pager-title">{nxt["num"]:02}. {html.escape(nxt["title"])}</span></a>'
        )

    pager.append("</nav>")

    packages = " ".join(f"<code>{html.escape(p)}</code>" for p in sorted(ex["imports"]))

    body = f"""<div class="layout">
{sidebar(examples, slug, base)}
<div class="content wide">
<main class="main example">
  <div class="page-header">
    <div class="eyebrow">{html.escape(part_of(ex["num"]))} · Example {ex["num"]:02}</div>
    <h1 class="page-title">{html.escape(ex["title"])}</h1>
    <div class="page-subtitle">{packages}</div>
  </div>
  <section class="intro prose">{ex["intro"]}</section>
  {"".join(body_parts)}
  {f'<div class="source-link"><a class="btn-secondary btn-sm" href="{REPO}/tree/main/{slug}">{ICON_GITHUB}View on GitHub</a></div>' if REPO else ''}
  {"".join(pager)}
</main>
</div>
</div>"""

    title = f"{ex['title']} · Rune"
    return page(title, body, base, f"Rune: Elixir by example, {ex['title']}")


def index_page(examples):
    packages = set().union(*(e["imports"] for e in examples))
    lines = sum(e["lines"] for e in examples)

    parts = []
    for name, lo, hi in PARTS:
        cards = []
        for e in examples:
            if lo <= e["num"] <= hi:
                cards.append(
                    f'<a class="lesson-card" href="{e["slug"]}/">'
                    f'<span class="lesson-num">{e["num"]:02}</span>'
                    f'<span class="lesson-title">{html.escape(e["title"])}</span></a>'
                )

        parts.append(
            f'<section class="part" data-part><h2 class="section-title">{html.escape(name)}'
            f'<span class="part-range">{lo:02}–{hi:02}</span></h2>'
            f'<div class="lesson-grid">{"".join(cards)}</div></section>'
        )

    stat = lambda label, value: (
        f'<div class="stat-card"><div class="stat-label">{label}</div>'
        f'<div class="stat-value">{value:,}</div></div>'
    )

    body = f"""<main class="home">
  <section class="hero">
    <div class="eyebrow">Elixir 1.19</div>
    <h1 class="hero-title">A hands-on introduction to Elixir, <br>one annotated example at a time.</h1>
    <p class="hero-sub">Each example is a complete program. The comments explain the code next
    to them, and the output underneath is what the program really prints. Start at the top
    for the language basics, or jump to processes and OTP.</p>
    <div class="hero-actions">
      <a class="btn-primary" href="{examples[0]["slug"]}/">Start with Hello World</a>
      {f'<a class="btn-secondary" href="{REPO}">{ICON_GITHUB}Clone the repo</a>' if REPO else ''}
    </div>
  </section>
  <section class="stats">
    {stat("Examples", len(examples))}{stat("Topics", len(PARTS))}{stat("Standard library modules", len(packages))}{stat("Lines of Elixir", lines)}
  </section>
  <div class="home-search"><input class="input-field" type="search" placeholder="Search examples  /" data-filter></div>
  {"".join(parts)}
</main>"""

    return page("Rune · Elixir by example", body, "", "Annotated, runnable Elixir examples.")


def not_found_page():
    body = """<main class="home not-found">
  <div class="eyebrow">404</div>
  <h1 class="hero-title">This page does not exist.</h1>
  <p class="hero-sub">The example may have been renamed.</p>
  <div class="hero-actions"><a class="btn-primary" data-home href="/">Browse all examples</a></div>
</main>
<script>document.querySelector('[data-home]').href=location.pathname.split('/').slice(0,2).join('/')+'/';</script>"""
    # The 404 page is served at any depth, so it links assets from the site root.
    return page("Not found · Rune", body, "/rune/", "Page not found")


def main():
    examples = [
        parse(f)
        for f in sorted(ROOT.glob("[0-9][0-9]_*"))
        if (f / "main.exs").is_file()
    ]

    if "--no-run" not in sys.argv:
        # Compile once so parallel mix run calls do not fight over the build lock.
        compiled = subprocess.run(
            ["mix", "compile"],
            cwd=ROOT,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
        )
        if compiled.returncode != 0:
            print(compiled.stdout, file=sys.stderr)
            sys.exit(compiled.returncode)

        run_outputs(examples)

    OUT.mkdir(exist_ok=True)
    for old in OUT.glob("[0-9][0-9]_*"):
        shutil.rmtree(old)

    shutil.rmtree(OUT / "assets", ignore_errors=True)
    (OUT / "assets").mkdir()
    shutil.copy(SITE / "style.css", OUT / "assets" / "style.css")
    shutil.copy(SITE / "site.js", OUT / "assets" / "site.js")
    shutil.copy(SITE / "hero.jpg", OUT / "assets" / "hero.jpg")
    (OUT / ".nojekyll").write_text("")

    for i, ex in enumerate(examples):
        prev = examples[i - 1] if i > 0 else None
        nxt = examples[i + 1] if i + 1 < len(examples) else None
        (OUT / ex["slug"]).mkdir()
        (OUT / ex["slug"] / "index.html").write_text(example_page(ex, prev, nxt, examples))

    (OUT / "index.html").write_text(index_page(examples))
    (OUT / "404.html").write_text(not_found_page())

    empty = [e["slug"] for e in examples if "shell" in e and not any(o for _, o in e["shell"])]
    if empty:
        print("no output for: " + ", ".join(empty), file=sys.stderr)

    print(f"wrote {len(examples)} examples to {OUT.relative_to(ROOT)}/")


if __name__ == "__main__":
    main()
