defmodule GistCloneWeb.AllGistLive do
  use GistCloneWeb, :live_view
  alias GistClone.{Gists}
  require Logger

  def mount(_params, _session, socket) do
    case Gists.list_gists_as_summary() do
      %Ecto.QueryError{} = error ->
        Logger.error("error occurred: #{inspect(error)}")
        {:ok, assign(socket, gists: [])}

      gists ->
        {:ok, assign(socket, gists: gists)}
    end
  end
end
