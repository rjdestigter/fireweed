defmodule FireweedWeb.Nutrition.Components.Fact do
  use Surface.Component

  prop(serving, :map, required: true)

  # defp format_weight(nutrient_value) do
  #   format_weight(nutrient_value, false)
  # end

  defp format_weight(nutrient_value, _unit) when is_nil(nutrient_value) do
    "-"
  end

  defp format_weight(nutrient_value, unit) do
    nutrient_value <> (unit || "g")
  end

  defp format_percent(_assigns, percentage) when is_nil(percentage) do
    nil
  end

  defp format_percent(assigns, percentage) do
    ~H"""
       <span class="font-black">{{ percentage |> format_number() }}</span><span>%</span>
    """
  end

  @spec format_number(any) :: <<_::8, _::_*8>>
  defp format_number(number) do
    number
    |> inspect
    |> String.split(".")
    |> (fn [n, m] -> n <> "." <> (m |> String.pad_trailing(2, "0")) end).()
  end

  defp render_nutrient(assigns, label: label, weight: weight, rdi: rdi) do
    render_nutrient(assigns, label: label, weight: weight, rdi: rdi, is_primary: false)
  end

  defp render_nutrient(assigns, label: label, weight: weight) do
    render_nutrient(assigns, label: label, weight: weight, rdi: nil, is_primary: false)
  end

  defp render_nutrient(assigns, label: label, weight: weight, is_primary: true) do
    render_nutrient(assigns, label: label, weight: weight, rdi: nil, is_primary: true)
  end

  defp render_nutrient(assigns, label: label, weight: weight, rdi: rdi, is_primary: is_primary) do
    render_nutrient(assigns,
      label: label,
      weight: weight,
      rdi: rdi,
      is_primary: is_primary,
      unit: "g"
    )
  end

  defp render_nutrient(assigns,
         label: label,
         weight: weight,
         rdi: rdi,
         is_primary: is_primary,
         unit: unit
       ) do
    rdi =
      if !is_nil(rdi) do
        ~H"""
        <td class="text-xs text-right border-t-1 border-nutrition-grey py-1 font-mono">
        {{ format_percent(assigns, rdi) }}
        </td>
        """
      end

    ~H"""
      <tr>
          <td colspan={{ is_nil(rdi) && 2 || 1 }} class="whitespace-no-wrap text-xs border-t-1 border-nutrition-grey py-1 {{ !is_primary && "pl-4" }}">
              <span class="{{ is_primary && "font-black" }} pr-2">{{label}}</span>
              <span class="font-mono">{{ format_weight(weight, unit) }}</span>
          </td>
          {{rdi}}
      </tr>
    """
  end

  def render(assigns) do
    ~H"""
      <section class="font-nutrition text-nutrition outline-nutrition px-6 py-6 inline-block bg-black-dark">
        <table class="m-0 border-collapse" width="255">
          <thead>
            <tr>
              <th colspan="2" class="font-black text-2xl pb-2 border-b-1 border-nutrition-grey">
                Nutrition Facts
              </th>
            </tr>
            <tr>
              <th colspan="2" class="text-sm border-b-11 border-nutrition-grey pb-2 pt-4 align-top">
                <div class="flex">
                  <div>Serving Size</div>
                  <div class="text-right flex-grow font-normal">{{ @serving["serving_description"] }}</div>
                </div>
              </th>
            </tr>
            <tr>
              <th class="border-b-6 border-nutrition-grey pb-2 align-top">
                <span class="text-sm whitespace-no-wrap">Amount Per Serving</span><br />
                <span class="text-2xl pb-1">Calories</span>
              </th>
              <th class="border-b-4 border-nutrition-grey pb-2 text-right align-bottom text-4xl">{{ @serving["calories"] }}</th>
            </tr>
          </thead>
          <tbody>
              <tr>
                <td class="text-xs text-right font-black py-1" colspan="2">% Daily Values*</td>
              </tr>
              {{ render_nutrient(assigns,
                  [label: "Total Fat", weight: @serving["fat"], rdi: RDI.fat(@serving["fat"]), is_primary: true]) }}
              {{ render_nutrient(assigns,
                  [label: "Saturated Fat", weight: @serving["saturated_fat"], rdi: RDI.saturated_fat(@serving["saturated_fat"])]) }}
              {{ render_nutrient(assigns,
                  [label: "Trans Fat", weight: @serving["trans_fat"]]) }}
              {{ render_nutrient(assigns,
                  [label: "Polyunsaturated Fat", weight: @serving["polyunsaturated_fat"]]) }}
              {{ render_nutrient(assigns,
                  [label: "Monounsaturated Fat", weight: @serving["monounsaturated_fat"]]) }}
              {{ render_nutrient(assigns,
                  [label: "Cholestorol", weight: @serving["cholestorol"] || "0", rdi: RDI.cholestorol(@serving["cholestorol"] || "0"), is_primary: true]) }}
              {{ render_nutrient(assigns,
                  [label: "Sodium", weight: @serving["sodium"] || "0", rdi: RDI.sodium(@serving["sodium"] || "0"), is_primary: true, unit: "mg"]) }}
              {{ render_nutrient(assigns,
                  [label: "Total Carbohydrate", weight: @serving["carbohydrate"], rdi: RDI.carbohydrate(@serving["carbohydrate"]), is_primary: true]) }}
              {{ render_nutrient(assigns,
                  [label: "Dietary Fiber", weight: @serving["fiber"], rdi: RDI.fiber(@serving["fiber"])]) }}
              {{ render_nutrient(assigns,
                  [label: "Sugar", weight: @serving["sugar"]]) }}
              {{ render_nutrient(assigns,
                  [label: "Protein", weight: @serving["protein"], is_primary: true]) }}
              <tr>
                <td colspan="2" class="border-b-11 border-nutrition-grey">
                </td>
              </tr>
              {{ render_nutrient(assigns,
                  [label: "Vitamin D", weight: @serving["vitamin_d"], is_primary: true]) }}
              {{ render_nutrient(assigns,
                  [label: "Calcium", weight: @serving["calcium"], rdi: RDI.calcium(@serving["calcium"]), is_primary: true, unit: "mg"]) }}
              {{ render_nutrient(assigns,
                  [label: "Iron", weight: @serving["iron"], rdi: RDI.iron(@serving["iron"]), is_primary: true, unit: "mg"]) }}
              {{ render_nutrient(assigns,
                  [label: "Potassium", weight: @serving["potassium"], rdi: RDI.potassium(@serving["potassium"]), is_primary: true, unit: "mg"]) }}
              {{ render_nutrient(assigns,
                  [label: "Vitamin A", weight: @serving["vitamin_a"], rdi: RDI.vitamin_a(@serving["vitamin_a"]), is_primary: true, unit: "mcg"]) }}
              {{ render_nutrient(assigns,
                  [label: "Vitamin C", weight: @serving["vitamin_c"], rdi: RDI.vitamin_c(@serving["vitamin_c"]), is_primary: true, unit: "mg"]) }}
            </tbody>
          </table>
        </section>
    """
  end
end
