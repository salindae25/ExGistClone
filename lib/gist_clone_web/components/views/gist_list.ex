defmodule GistCloneWeb.Views.GistList do
  use GistCloneWeb, :html

  def item(assigns) do
    ~H"""
    <div class="flex flex-col gap-8">
      <div class="flex w-full gap-3 items-start ">
        <img
          src="/images/user-image.svg"
          class="h-7 w-7 rounded-[50%] p-1 border-[1.5px] border-white"
          alt="profile image"
        />
        <div class="flex flex-col">
          <a href={~p"/gist?#{[id: @gist.id]}"}>
            <span class="text-emLavender-dark text-base flex items-center leading-3 font-bold  hover:underline">
              <span><%= String.split(@gist.user.email, "@") |> hd %></span>
              <span class="text-white px-0.5">/</span>
              <span><%= @gist.name %></span>
            </span>
          </a>
          <span
            id="date-update"
            phx-hook="DateHumanize"
            data-date={@gist.updated_at}
            class="text-white font-bold text-sm"
          >
            <%= @gist.updated_at %>
          </span>
          <span class="text-white text-xs font-regular capitalize"><%= @gist.description %></span>
        </div>
      </div>
      <div>
        <div class="flex px-2 py-4 font-regular text-sm item-center  bg-emDark rounded-t-md border border-b-0 h-14 border-white">
          <a href={~p"/gist?#{[id: @gist.id]}"}>
            <span class="text-emLavender-dark px-5 text-base font-bold hover:underline">
              <%= @gist.name %>
            </span>
          </a>
        </div>
        <div
          id={"highlighted-code-area-" <> @gist.id}
          phx-hook="HighlightText"
          class=" border border-white flex w-full max-h-[200px] overflow-hidden  rounded-b-md"
          data-name={@gist.name}
          data-code={@gist.markup_text}
        >
          <textarea
            id={"line-number-" <> @gist.id}
            class="min-w-[54px] w-[54px] rounded-bl-md border-r-0 bg-[#0d1117] text-emDark-light text-right overflow-hidden"
            readonly
            resize="off"
          >
               <%= "1\n" %>
          </textarea>
          <pre class="flex w-full text-white ">
            <code id={"code-tag"<> @gist.id} 
              class="language-elixir w-full max-h-[200px] overflow-hidden text-xs" 
              phx-hook="UpdateLineNumber" 
              data-line={"line-number-" <> @gist.id}
              >
              <%= @gist.markup_text %>
            </code>
          </pre>
        </div>
      </div>
    </div>
    """
  end
end
