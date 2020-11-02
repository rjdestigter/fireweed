defmodule Fireweed do
  @length 100

  @moduledoc """
  Fireweed keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defp spaced(str, c \\ " ") do
    length = String.length(str)
    if length < @length do
      spaces = for _ <- 1..(@length - length), into: "", do: c
      str <> spaces
    else
      str
    end
  end

  defp format(str, bg) do
    IO.ANSI.format([bg, :black, str])
  end

  def log(label, value, bgcolor \\ :yellow_background) do
    spaced("") |> format(bgcolor) |> IO.puts()
    spaced("", "-") |> format(bgcolor) |> IO.puts()
    ("| " <> label) |> spaced() |> format(bgcolor) |> IO.puts()
    spaced("", "-") |> format(bgcolor) |> IO.puts()
    value |> inspect |> spaced() |> format(bgcolor) |> IO.puts()
    spaced("", "-") |> format(bgcolor) |> IO.puts()
    spaced("") |> format(bgcolor) |> IO.puts()
  end
end
