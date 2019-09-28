defmodule Poker.CardClassification do
  @moduledoc """
  This is where the partial order of a hand is determined
  """
  @card_value %{
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "T" => 10,
    "J" => 11,
    "Q" => 12,
    "K" => 13,
    "A" => 14
  }

  @doc """
   partial_order_of_card/1 deteermines the partial order of a hand
  """
  @spec partial_order_of_card(String.t()) :: String.t()
  def partial_order_of_card(hand) do
    hand
    |> values_and_suits_of_cards()
    |> classify()
  end

  @doc """
  values_and_suits_of_cards/1 returns a list containg the suits and values of the cards that make up the hand
  """
  @spec values_and_suits_of_cards(String.t()) :: tuple()
  def values_and_suits_of_cards(hand) do
    hand
    |> String.split(" ")
    |> Enum.map(fn card ->
      %{suit: String.at(card, 1), value: String.at(card, 0)}
    end)
    |> Enum.reduce({[], []}, fn card, {suits, values} ->
      {List.insert_at(suits, -1, card.suit), List.insert_at(values, -1, card.value)}
    end)
  end

  defp classify({suits, values}) do
    case Enum.uniq(suits) |> Enum.count() do
      1 ->
        straight_flush_or_flush(values)

      _ ->
        if values |> integer_values() |> consecutive_values() do
          "Straight"
        else
          values |> number_of_same_values() |> classify()
        end
    end
  end

  defp classify([1, 2, 2]), do: "Two Pair"
  defp classify([1, 1, 1, 2]), do: "Pair"
  defp classify([1, 1, 3]), do: "Three of a kind"
  defp classify([1, 4]), do: "Four of a kind"
  defp classify([2, 3]), do: "Full hand"
  defp classify([1, 1, 1, 1, 1]), do: "High Card"
  defp classify([5]), do: "Straight"

  defp number_of_same_values(values) do
    values = values |> integer_values()

    values
    |> Enum.uniq()
    |> Enum.map(fn uniq_value ->
      Enum.count(values, fn specific_value -> specific_value == uniq_value end)
    end)
    |> Enum.sort()
  end

  defp straight_flush_or_flush(values) do
    if values |> integer_values() |> consecutive_values() do
      "Straight Flush"
    else
      "Flush"
    end
  end

  defp consecutive_values(values) do
    integer_values(values) == Enum.min(values)..Enum.max(values) |> Enum.to_list()
  end

  def integer_values(values) do
    Enum.map(values, fn value -> @card_value[value] end)
  end
end
