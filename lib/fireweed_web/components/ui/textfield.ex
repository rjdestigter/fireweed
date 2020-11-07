defmodule FireweedWeb.Components.UI.Textfield do
  use Surface.Components.Form.Input
  alias Surface.Components.Form.{TextInput, NumberInput, EmailInput, PasswordInput, InputContext}
  import FireweedWeb.ErrorHelpers
  alias Surface.Components.Form.Input.InputContext

  @class_wrapper "fw-textfield pt-4 inline-block mb-4 leading-4 text-textfield-label focus-within:text-primary "
  @class_textfield "px-2 h-12 bg-transparent outline-none border-b-1 border-textfield-border text-white-soft "
  @class_label "px-2 text-base font-semibold "

  prop label, :any, required: true
  prop type, :atom, default: :text

  def render(assigns) do
    # props = get_non_nil_props(assigns, [:value, class: @default_class])
    # event_opts = get_events_to_opts(assigns)

    class_wrapper = @class_wrapper
    class_textfield = @class_textfield
    class_label = @class_label

    input = case assigns.type do
      :email -> ~H"""
        <EmailInput class={{class_textfield}} />
      """
      :password -> ~H"""
        <PasswordInput class={{class_textfield}} />
      """
      :number -> ~H"""
        <NumberInput class={{class_textfield}} />
      """
      _ -> ~H"""
        <TextInput class={{class_textfield}} />
      """
    end

    ~H"""
    <InputContext assigns={{ assigns }} :let={{ form: form, field: field }}>
      <label class={{class_wrapper}}>
        <div class={{class_label}}>{{@label}}</div>
        {{input}}
        {{form && field && error_tag(form, field)}}
        <slot/>
      </label>
    </InputContext>
    """
  end
end
