defmodule GistCloneWeb.MyGistLive do
  use GistCloneWeb, :live_view
  alias GistClone.{Gists}

  def mount(_params, _session, socket) do
    gists =
      if socket.assigns.live_action == :your,
        do: Gists.list_gists(socket.assigns.current_user.id),
        else: Gists.list_gist_per_user_in_saved_gist(socket.assigns.current_user.id)

    {:ok, assign(socket, gists: gists)}
  end

  def render(assigns) do
    ~H"""
    <GistCloneWeb.Views.GistNav.main view={
      if @live_action == :your, do: "tabs-your-gist", else: "tabs-saved"
    }>
      <%= for gist <- @gists do %>
        <GistCloneWeb.Views.GistList.item gist={gist} />
      <% end %>
    </GistCloneWeb.Views.GistNav.main>
    """
  end
end
