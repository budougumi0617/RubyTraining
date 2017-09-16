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
end
