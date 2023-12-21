defmodule GistCloneWeb.EditGistLive do
  use GistCloneWeb, :live_view
  alias GistClone.{Gists, Gists.Gist}

  def mount(%{"id" => id}, _session, socket) do
    case Gists.get_gist!(id) do
      %Gist{} = gist ->
        socket = assign(socket, gist: gist, form: to_form(Gists.change_gist(gist)))
        {:ok, socket}

      _ ->
        {:noreply, push_navigate(socket, to: ~p"/")}
    end
  end

  def handle_event("update", %{"gist" => params}, socket) do
    case Gists.update_gist(socket.assigns.gist, params) do
      {:ok, gist} ->
        {:noreply, push_navigate(socket, to: ~p"/gist?#{[id: gist]}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("validate", %{"gist" => params}, socket) do
    changeset =
      %Gist{}
      |> Gists.change_gist(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def render(assigns) do
    ~H"""
    <div class="flex justify-center item-center gap-20 max-h-min em-gradient font-brand flex-col">
      <h1 class="text-white font-bold text-3xl mt-20 text-center">
        Instantly share your code, notes and snippets
      </h1>
      <GistCloneWeb.Views.GistEdit.gist_form form={@form} form_submit="update" />
    </div>
    """
  end
end
