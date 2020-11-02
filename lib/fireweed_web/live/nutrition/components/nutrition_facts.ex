defmodule FireweedWeb.Nutrition.Components.NutritionFacts do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use FireweedWeb, :live_component

  def format_weight(nutrient_value) do
    format_weight(nutrient_value, false)
  end

  def format_weight(nutrient_value, _unit) when is_nil(nutrient_value) do
    "-"
  end

  def format_weight(nutrient_value, unit) do
    nutrient_value <> (unit || "g")
  end

  def format_percent(_assigns, percentage) when is_nil(percentage) do
    nil
  end

  def format_percent(assigns, percentage) do
    ~L"""
       <span class="font-black"><%= percentage |> format_number() %></span><span>%</span>
    """
  end

  @spec format_number(any) :: <<_::8, _::_*8>>
  def format_number(number) do
    number
    |> inspect
    |> String.split(".")
    |> (fn [n, m] -> n <> "." <> (m |> String.pad_trailing(2, "0")) end).()
  end

  def render_nutrient(assigns, label: label, weight: weight, rdi: rdi) do
    render_nutrient(assigns, label: label, weight: weight, rdi: rdi, is_primary: false)
  end

  def render_nutrient(assigns, label: label, weight: weight) do
    render_nutrient(assigns, label: label, weight: weight, rdi: nil, is_primary: false)
  end

  def render_nutrient(assigns, label: label, weight: weight, is_primary: true) do
    render_nutrient(assigns, label: label, weight: weight, rdi: nil, is_primary: true)
  end

  def render_nutrient(assigns, label: label, weight: weight, rdi: rdi, is_primary: is_primary) do
    render_nutrient(assigns,
      label: label,
      weight: weight,
      rdi: rdi,
      is_primary: is_primary,
      unit: "g"
    )
  end

  def render_nutrient(assigns,
        label: label,
        weight: weight,
        rdi: rdi,
        is_primary: is_primary,
        unit: unit
      ) do
    ~L"""
      <tr>
          <td colspan="<%= is_nil(rdi) && 2 || 1 %>" class="whitespace-no-wrap text-xs border-t-1 border-nutrition-grey py-1 <%= !is_primary && "pl-4" %>">
              <span class="<%= is_primary && "font-black" %> pr-2"><%=label%></span>
              <span class="font-mono"><%= FireweedWeb.Nutrition.Components.NutritionFacts.format_weight(weight, unit) %></span>
          </td>
          <%= if !is_nil(rdi) do %>
          <td class="text-xs text-right border-t-1 border-nutrition-grey py-1 font-mono">
              <%= FireweedWeb.Nutrition.Components.NutritionFacts.format_percent(assigns, rdi) %>
          </td>
          <% end %>
      </tr>
    """
  end
end
