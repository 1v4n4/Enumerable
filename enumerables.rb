module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    for i in self
      yield(i)
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    if self.class == Array
      for i in self
        yield i, self.index(i)
      end
    elsif ((self.class == Range) || (self.class == Hash))
      for i in self
        yield i, to_a.index(i)
      end
    end
  end


  def my_select
    return to_enum(:my_select) unless block_given?
    selected = []
    for i in self
      selected.push(i) if yield(i)
    end
    selected
  end

  def my_all?(args = nil)
    result = true
    if block_given?
      for i in self
        result = false unless yield i
      end
    elsif args.nil?
      for i in self
        result = false if i.nil? || i == false
      end
    elsif !args.nil? and (args.is_a? Class)
      for i in self
        result = false if i.class != args
      end
    elsif !args.nil? and (args.is_a? Regexp)
      for i in self
        result = false if !(args.match(i))
      end
    else
      for i in self
        result = false if i != args
      end
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

  def my_map(proc = nil)
    mapped = []
    if proc
      for i in self
        mapped.push(proc.call(i))
      end
    elsif block_given?
      for i in self
        mapped.push(yield i)
      end
    end
    mapped
  end

  def my_inject (result = 0)
    self.my_each do |i|
      result = yield result, i
    end
    result
  end

end

def multiply_els(ar)
  ar.my_inject(1) {|multiply, num| multiply * num}
end

arr = [3, 4, 6, 2]
p arr.my_all? {|num| num > 2}
