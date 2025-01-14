<p align="center">
    <img src="assets/logo.svg" width="180" alt="Rune logo">
    <h3 align="center">Rune</h3>
    <p align="center">A hands-on introduction to Elixir, one annotated example at a time.</p>
</p>


## What's inside

Small Elixir programs, one topic each, in the spirit of [Elixir's getting started guide](https://elixir-lang.org/getting-started/introduction.html).
They go from values and pattern matching through processes, OTP, and the standard library.

Each folder holds a commented `main.exs` you can run on its own (Elixir 1.19+):

```zsh
$ elixir 01_hello_world/main.exs
```

Examples from GenStage onward use libraries. Fetch them once, then use the `Run:` line at the top of the script (`elixir` or `mix run`):

```zsh
$ mix deps.get
$ mix run 65_genstage/main.exs
```

## Website

To build and preview the examples with their output:

```zsh
$ python3 site/build.py
$ python3 -m http.server -d docs
```

## References

- [Getting started](https://elixir-lang.org/getting-started/introduction.html)
- [Elixir School](https://elixirschool.com/)
- [Documentation](https://hexdocs.pm/elixir/)
- [Mix and OTP](https://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html)
