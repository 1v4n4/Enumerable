module Enumerable
  def my_each
    for i in self
      yield(i)
    end
    self
  end

  def my_each_with_index    
    for i in self
      yield i, i - 1
    end
  end
end

hash = {:one => 1, :two => 2}
hash.my_each {|k, v| puts "#{k} => #{v}"}

arr = [1,2,3,4]
arr.my_each_with_index {|val, indx| puts "Index: #{indx} contains #{val}"}