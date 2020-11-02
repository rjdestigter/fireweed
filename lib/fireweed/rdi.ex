defmodule RDI do
  @default %{
    "fat" => 65,
    "fiber" => 25,
    "iron" => 14,
    "potassium" =>  4700,
    "saturated_fat" => 20,
    "trans_fat" => 0,
    "cholestorol" => 300,
    "carbohydrate" => 300,
    "calcium" => 1100,
    "sodium" => 2400,
    "vitamin_a" => 1000,
    "vitamin_c" => 60
  }

  def calculate(_nutrient, weight) when is_nil(weight) do
    nil
  end

  def calculate(nutrient, weight) when is_binary(weight) do
    {weight, ""} = Float.parse(weight)
    calculate(nutrient, weight)
  end

  def calculate(nutrient, weight) do
    (weight * 10000 / @default[nutrient]) |> round |> (fn p -> p / 100 end).()
  end

  def fat(weight), do: calculate("fat", weight)
  def trans_fat(weight), do: calculate("trans_fat", weight)
  def saturated_fat(weight), do: calculate("saturated_fat", weight)
  def cholestorol(weight), do: calculate("cholestorol", weight)
  def sodium(weight), do: calculate("sodium", weight)
  def carbohydrate(weight), do: calculate("carbohydrate", weight)
  def fiber(weight), do: calculate("fiber", weight)
  def calcium(weight), do: calculate("calcium", weight)
  def iron(weight), do: calculate("iron", weight)
  def potassium(weight), do: calculate("potassium", weight)
  def vitamin_a(weight), do: calculate("vitamin_a", weight)
  def vitamin_c(weight), do: calculate("vitamin_c", weight)
end
