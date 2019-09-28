defmodule Poker.ComparisonValue do
  alias Poker.CardClassification

  @moduledoc """
  this module contain functions that get the values to be compared from values of the cards in a single hand
  """

  @doc """
  get_comparison_value/1 takes in a hand and returns the value of the hand that will be used for comparison

  ## Example

      iex> Poker.ComparisonValue.get_comparison_value("2H 3D 5S 9C KD")
      13

  """
  @spec get_comparison_value(String.t()) :: integer()
  def get_comparison_value(hand) do
    {_suits, values} = CardClassification.values_and_suits_of_cards(hand)

    hand
    |> CardClassification.partial_order_of_hand()
    |> get_comparison_value(values)
  end

  @doc """
  get_comparison_value/2 takes in the partial order of a hand as the first argument
  and the values of a hand as a list and returns the value that will be used to compare the
  hand with another hand.

  ## Example

      iex> Poker.ComparisonValue.get_comparison_value("High Card", ["2", "3", "5", "9", "K"])
      13

  """
  @spec get_comparison_value(String.t(), list()) :: integer()
  def get_comparison_value(partial_order, values) do
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

  ## Examples

      iex> Poker.ComparisonValue.highest_value([2, 3, 5, 12, 13])
      13

  """
  @spec highest_value(list()) :: integer()
  def highest_value(values) do
    Enum.max(values)
  end

  @doc """
  multiple_card_value/1 gets the comparison values for hands which have cards with similar values. This works for
  four of a kind, full house, 3 of a kind and pair.

  ## Examples

      iex> Poker.ComparisonValue.multiple_card_value([2, 3, 13, 13, 13])
      13
      iex> Poker.ComparisonValue.multiple_card_value([2, 3, 5, 5, 9])
      5
      iex> Poker.ComparisonValue.multiple_card_value([1, 3, 4, 3, 4])
      4
      
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
