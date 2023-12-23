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

  def comment(assigns) do
    ~H"""
    <div class="flex w-full gap-8">
      <img
        src="/images/user-image.svg"
        class="h-10 w-10 rounded-[50%] p-1 border-[1.5px] border-white"
        alt="profile image"
      />
      <div class="flex flex-col w-full " id={"comment-header-"<> @comment.id} phx-update="ignore">
        <div class="flex px-2 py-4 gap-1 font-regular text-sm item-center  bg-emDark rounded-t-md border border-b-0 h-12 border-white text-white">
          <span>
            <%= @comment.user.email
            |> String.split("@")
            |> hd %>
          </span>
          <span
            id={"date-update"<> @comment.id}
            phx-hook="DateHumanize"
            data-prefix=" commented "
            data-date={@comment.updated_at}
          >
            <%= @comment.updated_at %>
          </span>
        </div>
        <div class="flex w-full min-h-[100px] px-3 py-4  rounded-b-md border-b border-x border-white  bg-emDark-dark text-white">
          <%= @comment.markup_text %>
        </div>
      </div>
    </div>
    """
  end

  def comment_edit(assigns) do
    ~H"""
    <.form
      for={@form}
      class="flex w-full gap-8"
      phx-submit={@form_submit}
      phx-change="validate_comment"
    >
      <img
        src="/images/user-image.svg"
        class="h-10 w-10 rounded-[50%] p-1 border-[1.5px] border-white"
        alt="profile image"
      />
      <div class="flex flex-col w-full ">
        <div class="flex px-2 py-4 font-regular text-sm item-center  bg-emDark rounded-t-md border border-b-0 h-12 border-white">
        </div>
        <div class="flex flex-col gap-3 px-3 py-4  w-full rounded-b-md border-b border-x border-white bg-emDark-dark">
          <GistCloneWeb.CoreComponents.input field={@form[:gist_id]} style="display:none" />
          <%= textarea(@form, :markup_text,
            id: "comment-textarea",
            style: "border-top:1px solid white",
            class:
              "w-full rounded-md border border-white bg-emDark-dark text-white placeholder:text-white h-[120px]",
            placeholder: "Leave a message here",
            autocomplete: "off",
            spellcheck: "false",
            phx_debounce: "blur"
          ) %>

          <div class="flex justify-end item-center">
            <GistCloneWeb.CoreComponents.button class="create_button" phx-disable-with="Adding...">
              Add
            </GistCloneWeb.CoreComponents.button>
          </div>
        </div>
      </div>
    </.form>
    """
  end
end
