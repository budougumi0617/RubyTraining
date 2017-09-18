class Array
  # 1から100までを順に含んだ配列を返す
  def self.sort_array
    (1..100).to_a
  end

  # 引数配列の各要素を100倍にした配列を返す
  def self.array_times_100(a)
    a.collect{|i| i * 100 }
  end

  # 引数配列の各要素を100倍にする。
  def self.array_times_100!(a)
    a.collect!{|i| i * 100 }
  end

  # 10要素ずつの複数配列を返す。
  def self.arrays
    ary = (1..100).to_a
    result = Array.new
    10.times do |i|
      result << ary[i*10, 10]
    end
    result
  end
end
