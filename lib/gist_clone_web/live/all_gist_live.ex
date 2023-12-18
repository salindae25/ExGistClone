defmodule GistCloneWeb.AllGistLive do
  use GistCloneWeb, :live_view
  alias GistClone.{Gists, Gists.Gist}
  require Logger

  def mount(_params, _session, socket) do
    gists = Gists.list_gists()
    {:ok, assign(socket, gists: gists)}
  end

  def handle_event("delete", %{"id" => params}, socket) do
    case Gists.get_gist!(params) do
      %Gist{} = gist ->
        case Gists.delete_gist(gist) do
          {:ok, _gist} ->
            {:noreply,
             update(socket, :gists, fn gists ->
               Enum.filter(gists, fn g -> g.id != gist.id end)
             end)}

          {:error, _changeset} ->
            {:noreply, socket}
        end

      _ ->
        {:noreply, socket}
    end
  end
end
