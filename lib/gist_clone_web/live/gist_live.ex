defmodule GistCloneWeb.GistLive do
  use GistCloneWeb, :live_view
  alias GistClone.{Gists, Gists.Gist}

  def mount(%{"id" => id}, _session, socket) do
    gist = Gists.get_gist!(id)
    {:ok, assign(socket, gist: gist)}
  end
end
