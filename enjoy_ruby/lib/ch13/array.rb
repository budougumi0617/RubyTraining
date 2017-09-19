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

  # 配列の各要素を足し合わせた配列を返す。
  def sum_array(ary1, ary2)
    result = Array.new
    i = 0
    ary1.each do |elem1|
      result &lt;&lt; elem1 + ary2[i]
      i+=1
    end
    return result
  end

end
