defmodule Poker.ComparisonValue do
  alias Poker.CardClassification

  @moduledoc """
  this module contain functions that get the values to be compared from values of the cards in a single hand
  """

  def get_comparison_value(hand) do
    partial_order = CardClassification.partial_order_of_card(hand)
    {_suits, values} = CardClassification.values_and_suits_of_cards(hand)

    case partial_order do
      partial_order when partial_order in ["Straight", "Straight Flush", "Flush", "High Card"] ->
        values |> CardClassification.integer_values() |> highest_value()

      _ ->
        values |> CardClassification.integer_values() |> multiple_card_value()
    end
  end

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
