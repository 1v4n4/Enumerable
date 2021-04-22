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


  def my_select
    selected = []
    for i in self
      if yield(i)
      selected.push(i)
      end
    end
    selected
  end
end



hash = {:one => 1, :two => 2}
hash.my_each {|k, v| puts "#{k} => #{v}"}

arr = [1, 2, 5, 3, 4]
p arr.my_select {|i| arr[i] > 1}

friends = ['Sharon', 'Leo', 'Leila', 'Brian', 'Arun']

friends.my_select { |friend| friend != 'Brian' }
