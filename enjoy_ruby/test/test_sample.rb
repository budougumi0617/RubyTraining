require 'test/unit'
require 'sample.rb'

class TestSample < Test::Unit::TestCase
  def test_greeting
    assert_equal 'Hello, world!', Sample.greeting
  end
end
