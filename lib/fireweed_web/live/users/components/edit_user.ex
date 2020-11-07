defmodule FireweedWeb.UsersLive.Components.EditUser do
  use FireweedWeb, :surface_component

  prop changeset, :any, required: true

  def render(assigns) do
    ~H"""
      <div class="p-4 text-base " style="flex: 0 0 320px">
         <Form for={{@changeset}} change="validate">
            <Field name="name">
              <Textfield label={{"Name"}} />
            </Field>
            <Field name="email">
              <Textfield type={{:email}} label={{"Email"}} />
            </Field>
        </Form>
      </div>
    """
  end
end
