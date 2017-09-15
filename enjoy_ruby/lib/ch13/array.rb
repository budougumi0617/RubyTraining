class Array
  def self.sort_array
    (1..100).to_a
  end

  def self.array_times_100(a)
    a.collect{|i| i * 100 }
  end

  def self.array_times_100!(a)
    a.collect!{|i| i * 100 }
  end
end
