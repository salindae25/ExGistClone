defmodule GistCloneWeb.Views.GistEdit do
  use Phoenix.Component
  import Phoenix.HTML.Form

  attr :form, :any, required: true, doc: "the datastructure for the form"
  attr :form_submit, :any, doc: "the atom to fire for submit"

  def gist_form(assigns) do
    ~H"""
    <.form for={@form} class="flex w-full flex-col" phx-submit={@form_submit} phx-change="validate">
      <div
        class="flex flex-col justify-center px-28 space-y-4 w-full mb-10"
        style="padding-inline:clamp(80px, 15%, 15rem)"
      >
        <GistCloneWeb.CoreComponents.input
          field={@form[:description]}
          class="w-full h-full"
          placeholder="Gist description..."
          autocomplete="off"
          phx-debounce="blur"
        />
        <div>
          <div class="flex px-2 pt-2 pb-4 bg-emDark rounded-t-md border border-b-0 border-white">
            <div class="w-[300px]">
              <GistCloneWeb.CoreComponents.input
                field={@form[:name]}
                placeholder="Filename with extension...."
                autocomplete="off"
                phx-debounce="blur"
              />
            </div>
          </div>
          <div id="gist-markuparea" class="flex w-full" phx-update="ignore">
            <textarea
              id="line-number"
              class="w-[54px] rounded-bl-md border-r-0 text-emDark-light text-right overflow-hidden"
              readonly
            >
          <%= "1\n" %>
          </textarea>
            <%= textarea(@form, :markup_text,
              id: "gist-textarea",
              phx_hook: "UpdateLineNumber",
              class: "w-full rounded-br-md border-l-0",
              placeholder: "Insert Code...",
              autocomplete: "off",
              spellcheck: "false",
              phx_debounce: "blur"
            ) %>
          </div>
        </div>

        <div class="flex justify-end item-center">
          <GistCloneWeb.CoreComponents.button class="create_button" phx-disable-with="Creating...">
            Save gist
          </GistCloneWeb.CoreComponents.button>
        </div>
      </div>
    </.form>
    """
  end
end
