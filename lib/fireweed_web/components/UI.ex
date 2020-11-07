defmodule UI do
  import Phoenix.HTML
  # import Phoenix.HTML.Tag
  import Phoenix.HTML.Form
  import FireweedWeb.ErrorHelpers

  @class_textfield_wrapper "fw-textfield pt-4 inline-block mb-4 leading-4 text-textfield-label focus-within:text-primary "
  @class_textfield "px-2 h-12 bg-transparent outline-none border-b-1 border-textfield-border text-white-soft "
  @class_label "px-2 text-base font-semibold "

  def textfield(form, field, attrs) when is_list(attrs) do
    textfield(form, field, attrs, nil)
  end

  def textfield(form, field, do: block) do
    textfield(form, field, [], block)
  end

  def textfield(form, field, attrs, do: block) do
    textfield(form, field, attrs, block)
  end

  def textfield(form, field, attrs, content) do
    class = @class_textfield_wrapper  <> Keyword.get(attrs, :class, "")
    rest = Keyword.delete(attrs, :class)
    lbl = Keyword.get(attrs, :label) || Keyword.get(attrs, :placeholder)

    assigns = %{
      class_label: @class_label,
      class_textfield: @class_textfield
    }

    ~E"""
      <%= label(form, field, class: class) do %>
        <div class="<%=@class_label%>"><%= lbl %></div>
        <%= text_input(form, field, [{:class, @class_textfield}, {:phx_debounce, "blur"} | rest]) %>
        <%= error_tag(form, field) %>
        <%= content %>
      <% end %>
    """
  end

  def emailfield(form, field, attrs \\ []), do: textfield(form, field, Keyword.put(attrs, :type, "email"))
  def passwordfield(form, field, attrs \\ []), do: textfield(form, field, Keyword.put(attrs, :type, "password"))
  def newpasswordfield(form, field, attrs \\ []), do: passwordfield(form, field, Keyword.put(attrs, :autocomplete, "new-password"))
end
