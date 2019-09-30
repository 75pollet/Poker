defmodule Poker.CardRanking do
  @moduledoc """
  in this module, hands are ranked and the winning hand is determined
  """
  alias Poker.ComparisonValue
  alias Poker.CardClassification
  @card_value %{10 => "T", 11 => "Jack", 12 => "Queen", 13 => "King", 14 => "Ace"}

  @doc """
  rank_hands/2 takes in two hands, compares them and determines 
  the hand with the higher rank

  ## Examples

      iex> Poker.CardRanking.rank_hands("2H 3D 5S 9C KD", "2C 3H 4S 8C KH")
      "Black wins - High Card: 9"

  """
  @spec rank_hands(String.t(), String.t()) :: String.t()
  def rank_hands(black, white) do
    if tie?(black, white) do
      "Tie"
    else
      proceed_with_ranking(black, white)
    end
  end

  defp proceed_with_ranking(black, white) do
    {b_partial_order, b_value} = partial_order_and_value(black)
    {w_partial_order, w_value} = partial_order_and_value(white)

    b_value
    |> compare_hands(w_value, b_partial_order, w_partial_order)
    |> proceed_with_ranking(black, white, {b_partial_order, b_value}, {w_partial_order, w_value})
  end

  defp proceed_with_ranking(
         "values are the same",
         black,
         white,
         {b_partial_order, b_value},
         {w_partial_order, w_value}
       ) do
    rank_hands_with_next_value(
      black,
      white,
      {b_partial_order, b_value},
      {w_partial_order, w_value}
    )
  end

  defp proceed_with_ranking(result, _, _, _, _) do
    result
  end

  defp rank_hands_with_next_value(
         black,
         white,
         {b_partial_order, b_value},
         {w_partial_order, w_value}
       ) do
    {new_b_value, new_w_value} =
      get_new_values(
        black,
        white,
        {b_partial_order, b_value},
        {w_partial_order, w_value}
      )

    compare_hands(new_b_value, new_w_value, b_partial_order, w_partial_order)
  end

  defp get_new_values(
         black,
         white,
         {b_partial_order, b_value},
         {w_partial_order, w_value}
       ) do
    {_suits, values_for_black} = CardClassification.values_and_suits_of_cards(black)
    {_suits, values_for_white} = CardClassification.values_and_suits_of_cards(white)

    black_values = values_for_black |> CardClassification.integer_values() |> List.delete(b_value)
    white_values = values_for_white |> CardClassification.integer_values() |> List.delete(w_value)

    {ComparisonValue.get_comparison_value(b_partial_order, black_values),
     ComparisonValue.get_comparison_value(w_partial_order, white_values)}
  end

  defp tie?(black, white) do
    {_suits, values_for_black} = CardClassification.values_and_suits_of_cards(black)
    {_suits, values_for_white} = CardClassification.values_and_suits_of_cards(white)
    values_for_black == values_for_white
  end

  defp compare_hands(_b_value, _w_value, b_partial_order, _w_partial_order)
       when b_partial_order in ["Flush", "Straight"] do
    "Black wins - #{b_partial_order}"
  end

  defp compare_hands(_b_value, _w_value, _b_partial_order, w_partial_order)
       when w_partial_order in ["Flush", "Straight"] do
    "White wins - #{w_partial_order}"
  end

  defp compare_hands(b_value, w_value, b_partial_order, w_partial_order) do
    compare_values(b_value, w_value, b_partial_order, w_partial_order)
  end

  defp compare_values(black_value, white_value, b_partial_order, _)
       when black_value > white_value do
    "Black wins - #{b_partial_order}: #{get_value(black_value)}"
  end

  defp compare_values(black_value, white_value, _, w_partial_order)
       when white_value > black_value do
    "White wins - #{w_partial_order}: #{get_value(white_value)}"
  end

  defp compare_values(_black_value, _white_value, _, _) do
    "values are the same"
  end

  defp get_value(value) when value < 10 do
    value
  end

  defp get_value(value) do
    @card_value[value]
  end

  defp partial_order_and_value(hand) do
    {CardClassification.partial_order_of_hand(hand), ComparisonValue.get_comparison_value(hand)}
  end
end
