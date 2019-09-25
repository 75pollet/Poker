defmodule PokerTest do
  use ExUnit.Case
  alias Poker.CardClassification
  doctest Poker

  test "greets the world" do
    assert Poker.hello() == :world
  end

  test "the partial order of a card can be determined" do
    assert CardClassification.partial_order_of_card("2H 3D 5S 9C KD") == "High Card"
    assert CardClassification.partial_order_of_card("2S 8S AS QS 3S") == "Flush"
    assert CardClassification.partial_order_of_card("2H 3D 3S 9C KD") == "Pair"
    assert CardClassification.partial_order_of_card("2H 3D 3S 9C 9D") == "Two Pair"
    assert CardClassification.partial_order_of_card("2H 3D 9S 9C 9D") == "Three of a kind"
    assert CardClassification.partial_order_of_card("2H 9D 9S 9C 9D") == "Four of a kind"
    assert CardClassification.partial_order_of_card("2H 2D 9S 9C 9D") == "Full hand"
    assert CardClassification.partial_order_of_card("9H 9D 9S 9C 9D") == "Straight"
  end
end
