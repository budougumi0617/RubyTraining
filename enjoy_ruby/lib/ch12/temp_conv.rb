class TempConv
    # Return fahrenheit.
    def self.cels_to_fahr c
        c * 9 / 5.to_f + 32
    end

    # Return celsius.
    def self.fahr_to_cels f
        ((f - 32) * 5 / 9.to_f).round(4)
    end

    # 
end
