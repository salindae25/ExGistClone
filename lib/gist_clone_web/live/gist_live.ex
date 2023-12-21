defmodule GistCloneWeb.GistLive do
  use GistCloneWeb, :live_view
  alias GistClone.{Gists, Gists.Gist}
  import Logger

  def mount(%{"id" => id}, _session, socket) do
    gist = Gists.get_gist_with_all!(id)
    saved_count = Gists.count_of_saved_gist_per_gist(id)

    is_current_user_save_gist =
      case Gists.saved_gist_with_user_and_gist(socket.assigns.current_user.id, id) do
        0 -> false
        _ -> true
      end

    {:ok,
     assign(socket,
       gist: gist,
       saved_count: saved_count,
       has_saved_gist: is_current_user_save_gist
     )}
  end

  def handle_event("save", %{"id" => id}, socket) do
    case socket.assigns.has_saved_gist do
      false ->
        case(Gists.create_saved_gist(socket.assigns.current_user, %{gist_id: id})) do
          {:ok, _saved_gist} ->
            {:noreply,
             assign(socket, saved_count: socket.assigns.saved_count + 1, has_saved_gist: true)}

          {:error, %Ecto.Changeset{} = _changeset} ->
            {:noreply, socket}
        end

      true ->
        case Gists.delete_saved_gist_using_user_and_gist(socket.assigns.current_user.id, id) do
          {1, nil} ->
            {:noreply,
             assign(socket, saved_count: socket.assigns.saved_count - 1, has_saved_gist: false)}

          {:error, changeset} ->
            log(:warning, changeset)
            {:noreply, socket}
        end
    end
  end

  def handle_event("delete", %{"id" => params}, socket) do
    case Gists.get_gist!(params) do
      %Gist{} = gist ->
        case Gists.delete_gist(gist) do
          {:ok, _gist} ->
            {:noreply, push_navigate(socket, to: ~p"/all_gist")}

          {:error, _changeset} ->
            {:noreply, socket}
        end

      _ ->
        {:noreply, socket}
    end
  end
end
