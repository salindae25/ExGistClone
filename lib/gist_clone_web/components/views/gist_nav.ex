defmodule GistCloneWeb.Views.GistNav do
  use GistCloneWeb, :html

  attr :view, :any, default: "tab-your-gist"
  slot :inner_block, required: true

  def main(assigns) do
    ~H"""
    <div
      class="flex w-full px-20 em-gradient pt-8 items-end"
      style="padding-inline:clamp(80px, 15%, 15rem)"
    >
      <ul
        id=""
        class="mb-5 flex w-full list-none  border-b border-white pl-0 text-white "
        role="tablist"
        data-te-nav-ref
      >
        <li role="presentation">
          <a
            href={~p"/user/my_gists"}
            class="mt-2 text-white block border-x-0 border-b-2 border-t-0 border-transparent px-7 pb-3.5 pt-4 text-2xl font-medium uppercase leading-tight  hover:isolate hover:border-transparent hover:bg-emPurple focus:isolate focus:border-transparent aria-selected:border-white items-baseline gap-1"
            data-te-toggle="pill"
            data-te-target="#tabs-your-gist"
            data-te-nav-active={if @view == "tabs-your-gist", do: "true", else: "false"}
            role="tab"
            aria-controls="tabs-your-gist"
            aria-selected={if @view == "tabs-your-gist", do: "true", else: "false"}
          >
            <GistCloneWeb.CoreComponents.icon name="hero-code-bracket" class="h-9 w-9" /> Your Gists
          </a>
        </li>
        <li role="presentation">
          <a
            href={~p"/user/saved"}
            class="mt-2 text-white block border-x-0 border-b-2 border-t-0 border-transparent px-7 pb-3.5 pt-4 text-2xl font-medium uppercase leading-tight  hover:isolate hover:border-transparent hover:bg-emPurple focus:isolate focus:border-transparent aria-selected:border-white items-baseline gap-1"
            data-te-toggle="pill"
            data-te-target="#tabs-saved"
            data-te-nav-active={if @view == "tabs-saved", do: "true", else: "false"}
            role="tab"
            aria-selected={if @view == "tabs-saved", do: "true", else: "false"}
            aria-controls="tabs-saved"
          >
            <GistCloneWeb.CoreComponents.icon name="hero-bookmark" class="h-9 w-9" /> Saved
          </a>
        </li>
      </ul>
    </div>

    <div
      class="flex w-full mt-20 font-brand flex-col gap-20 pb-10"
      style="padding-inline:clamp(80px, 15%, 15rem)"
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
