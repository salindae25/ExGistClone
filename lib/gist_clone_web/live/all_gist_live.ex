defmodule GistCloneWeb.AllGistLive do
  use GistCloneWeb, :live_view
  alias GistClone.{Gists, Gists.Gist}
  require Logger

  def mount(_params, _session, socket) do
    gists = Gists.list_gists_with_user()
    {:ok, assign(socket, gists: gists)}
  end
end
