require 'test/unit'
require 'temp_conv'

class TestTempConv < Test::Unit::TestCase
    def test_cels_to_fahr
        assert_equal 32, TempConv.cels_to_fahr(0)
        assert_equal 53.6, TempConv.cels_to_fahr(12)
    end
end
