require 'test/unit'
require 'ch13/array'

class TestArray < Test::Unit::TestCase
  def test_sort_array
    actual = Array.sort_array
    (1..100).each do |expect|
      assert_true expect == actual[expect - 1]
    end
  end
end
