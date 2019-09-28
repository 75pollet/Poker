defmodule Poker.ComparisonValue do
  @doc """
  highest_value/1 returns the value of the highest value card in a hand. This 
  is used for the following partial orders: straight, flush, straight flush and high card.
  """
  @spec highest_value(list()) :: integer()
  def highest_value(values) do
    Enum.max(values)
  end

  @doc """
  multiple_card_value/1 gets the comparison values for hands which have cards with similar values. This works for
  four of a kind, full house, 3 of a kind and pair.
  """
  @spec multiple_card_value(list()) :: integer()
  def multiple_card_value(values) do
    values
    |> Enum.sort(&(&1 >= &2))
    |> Enum.chunk_by(fn value -> value end)
    |> Enum.max_by(fn value -> Enum.count(value) end)
    |> Enum.at(0)
  end
end
