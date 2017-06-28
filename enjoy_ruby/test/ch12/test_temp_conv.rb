require 'test/unit'
require 'ch12/temp_conv'

class TestTempConv < Test::Unit::TestCase
    def test_cels_to_fahr
        assert_equal 32, TempConv.cels_to_fahr(0)
        assert_equal 53.6, TempConv.cels_to_fahr(12)
    end

    def test_fahr_to_cels
        assert_equal 0, TempConv.fahr_to_cels(32)
        assert_equal 37.7778, TempConv.fahr_to_cels(100)
    end
end
