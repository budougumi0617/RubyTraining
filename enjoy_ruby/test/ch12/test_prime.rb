require 'test/unit'
require 'ch12/prime'


class TestPrime < Test::Unit::TestCase
  def test_prime
    assert_true Prime.prime?(7)
    assert_false Prime.prime?(8)
  end
end
