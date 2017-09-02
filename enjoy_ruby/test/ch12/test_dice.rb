require 'test/unit'
require 'ch12/dice'

class TestDice < Test::Unit::TestCase
  def test_dice
    result = Dice.dice
    assert_true 1 <= result && result <= 6
  end

  def test_dice10
    assert_true Dice.dice10 != Dice.dice10
  end
end
