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
      selected.push(i) if yield(i)
    end
    selected
  end

  def my_all?
    result = true
    for i in self
      result = false unless yield i
    end
    result
  end

  def my_any?
    result = false
    for i in self
      result = true if yield i
    end
    result
  end

  def my_none?
    result = true
    for i in self
      result = false if yield i
    end
    result
  end

  def my_count
    counter = 0
    for i in self
      if yield(i)
        counter +=1
      end
    end
    return counter
  end

  def my_map
    mapped = []
    for i in self
      mapped.push(yield i)
    end
    mapped
  end

end



hash = {:one => 1, :two => 2}
hash.my_each {|k, v| puts "#{k} => #{v}"}

arr = [1, 2, 5, 3, 4]
p arr.my_map {|i| i*3}

friends = ['Sharon', 'Leo', 'Leila', 'Brian', 'Arun']

p friends.my_select { |friend| friend != 'Brian' }

