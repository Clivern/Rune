# Phoenix
#
# A router matches a request to a controller action. The endpoint is the plug
# that receives the connection. Phoenix.ConnTest builds a connection and
# dispatches it without opening a port.
#
# Run: mix run 74_phoenix/main.exs

Logger.configure(level: :none)

Application.put_env(:rune, RuneWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 0],
  server: false,
  url: [host: "localhost"],
  secret_key_base: String.duplicate("a", 64),
  render_errors: [formats: [html: RuneWeb.PageController], layout: false]
)

defmodule RuneWeb.PageController do
  use Phoenix.Controller, formats: [:html]

  def index(conn, _params) do
    html(conn, "<p>hello ada</p>")
  end
end

defmodule RuneWeb.Router do
  use Phoenix.Router

  pipeline :browser do
    plug(:accepts, ["html"])
  end

  scope "/", RuneWeb do
    pipe_through(:browser)
    get("/", PageController, :index)
  end
end

defmodule RuneWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :rune

  plug(RuneWeb.Router)
end

defmodule Demo do
  import Phoenix.ConnTest
  @endpoint RuneWeb.Endpoint

  def run do
    {:ok, _pid} = RuneWeb.Endpoint.start_link()
    body = build_conn() |> get("/") |> response(200)
    IO.puts(body)
  end
end

Demo.run()
