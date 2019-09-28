defmodule PokerTest do
  use ExUnit.Case
  alias Poker.CardClassification
  alias Poker.CardRanking
  alias Poker.ComparisonValue

  doctest CardClassification
  doctest CardRanking
  doctest ComparisonValue

  test "the partial order of a card can be determined" do
    assert CardClassification.partial_order_of_hand("2H 3D 5S 9C KD") == "High Card"
    assert CardClassification.partial_order_of_hand("2S 8S AS QS 3S") == "Flush"
    assert CardClassification.partial_order_of_hand("2H 3D 3S 9C KD") == "Pair"
    assert CardClassification.partial_order_of_hand("2H 3D 3S 9C 9D") == "Two Pair"
    assert CardClassification.partial_order_of_hand("2H 3D 9S 9C 9D") == "Three of a kind"
    assert CardClassification.partial_order_of_hand("2H 9D 9S 9C 9D") == "Four of a kind"
    assert CardClassification.partial_order_of_hand("2H 2D 9S 9C 9D") == "Full hand"
    assert CardClassification.partial_order_of_hand("9H 9D 9S 9C 9D") == "Straight"
  end

  test "The first integer value to be used in comparing two hands can be retrieved from a hand" do
    assert ComparisonValue.get_comparison_value("2H 3D 5S 9C KD") == 13
    assert ComparisonValue.get_comparison_value("2H 3D 5S 9C 7D") == 9
    assert ComparisonValue.get_comparison_value("2H 5D 5S 9C 8D") == 5
    assert ComparisonValue.get_comparison_value("7H 6D 6S 9C 7D") == 7
    assert ComparisonValue.get_comparison_value("2H 9D 9S 9C 9D") == 9
    assert ComparisonValue.get_comparison_value("2S 8S AS QS 3S") == 14
    assert ComparisonValue.get_comparison_value("2H 2D 9S 9C 9D") == 9
  end

  test "Cards can be ranked" do
    assert CardRanking.rank_hands("2H 3D 5S 9C KD", "2C 3H 4S 8C AH") ==
             "White wins - High Card: Ace"

    assert CardRanking.rank_hands("2H 3D 5S 9C KD", "2C 3H 4S 8C KH") ==
             "Black wins - High Card: 9"

    assert CardRanking.rank_hands("2H 4S 4C 3D 4H", "2S 8S AS QS 3S") == "White wins - Flush"
    assert CardRanking.rank_hands("2H 3D 5S 9C KD", "2D 3H 5C 9S KH") == "Tie"
  end
end
