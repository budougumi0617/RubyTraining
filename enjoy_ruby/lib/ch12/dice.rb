class Dice
  # Return number like a dice.
  def self.dice
    Random.rand(6) + 1
  end

  def self.dice10
    ret = 0
    10.times do
      ret += dice
    end
    ret
  end
end
