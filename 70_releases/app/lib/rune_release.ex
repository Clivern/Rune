# The application callback. A release starts this module on boot.
defmodule RuneRelease do
  use Application

  @impl true
  def start(_type, _args) do
    Supervisor.start_link([], strategy: :one_for_one, name: RuneRelease.Supervisor)
  end
end
