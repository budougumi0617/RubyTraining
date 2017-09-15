require 'test/unit'
require 'ch13/array'

class TestArray < Test::Unit::TestCase
  def test_sort_array
    actual = Array.sort_array
    (1..100).each do |expect|
      assert_true expect == actual[expect - 1]
    end
  end

  def test_times_100
    a = (1..100).to_a
    actual = Array.array_times_100(a)
    (1..100).each do |i|
      assert_true i * 100 == actual[i - 1]
    end
  end

  def test_times_100!
    a = (1..10).to_a
    Array.array_times_100!(a)
    (1..10).each do |i|
      assert_true i * 100 == a[i - 1]
    end
  end
end
