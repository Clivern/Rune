# LiveView
#
# A LiveView renders HTML from assigns. mount sets the first assigns.
# live/2 from Phoenix.LiveViewTest mounts the view and returns the rendered
# page, using the same endpoint and router as a browser request.
#
# Run: mix run 75_liveview/main.exs

Logger.configure(level: :none)

Application.put_env(:rune, RuneWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 0],
  server: false,
  url: [host: "localhost"],
  secret_key_base: String.duplicate("a", 64),
  live_view: [signing_salt: "aaaaaaaa"],
  pubsub_server: Rune.PubSub,
  render_errors: [formats: [html: RuneWeb.HomeLive], layout: false]
)

defmodule RuneWeb.HomeLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, assign(socket, name: "ada")}
  end

  def render(assigns) do
    ~H"""
    <p>hello {@name}</p>
    """
  end
end

defmodule RuneWeb.Router do
  use Phoenix.Router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug(:accepts, ["html"])
  end

  scope "/", RuneWeb do
    pipe_through(:browser)
    live("/", HomeLive)
  end
end

defmodule RuneWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :rune

  socket("/live", Phoenix.LiveView.Socket)
  plug(RuneWeb.Router)
end

ExUnit.configure(seed: 0, formatters: [])
ExUnit.start(autorun: false)

defmodule DemoTest do
  use ExUnit.Case, async: false
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  @endpoint RuneWeb.Endpoint

  setup do
    start_supervised!({Phoenix.PubSub, name: Rune.PubSub})
    start_supervised!(RuneWeb.Endpoint)
    :ok
  end

  test "renders the name" do
    {:ok, _view, html} = live(build_conn(), "/")
    assert html =~ "hello ada"
  end
end

%{failures: 0, total: 1} = ExUnit.run()
IO.puts("rendered")
