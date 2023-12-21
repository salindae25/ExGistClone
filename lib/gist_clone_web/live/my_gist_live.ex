defmodule GistCloneWeb.MyGistLive do
  use GistCloneWeb, :live_view
  alias GistClone.{Gists}

  def mount(_params, _session, socket) do
    gists = Gists.list_gists(socket.assigns.current_user.id)
    {:ok, assign(socket, gists: gists)}
  end

  def render(assigns) do
    ~H"""
    <div class="flex w-full px-20 em-gradient pt-8" style="padding-inline:clamp(80px, 15%, 15rem)">
    </div>

    <div
      class="flex w-full mt-20 font-brand flex-col gap-20 pb-10"
      style="padding-inline:clamp(80px, 15%, 15rem)"
    >
      <%= for gist <- @gists do %>
        <GistCloneWeb.Views.GistList.item gist={gist} />
      <% end %>
    </div>
    """
  end
end
