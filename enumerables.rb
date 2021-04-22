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

  def my_any? (args = nil)
    result = false
    if block_given?
      for i in self
        result = true if yield i
      end
    elsif !args.nil? && (args.is_a? Class)
      for i in self
        result = true if i.class == args
      end
    elsif !args.nil? && (args == Regexp)
      for i in self
        result = true if args.match(i)
      end
    else
      for i in self
        result = true if i == args
      end
    end
    result
  end

# when no block or argument is given returns true only if none of the collection members is true
# when no block or argument is given returns false only if one of the collection members is true
# when a class is passed as an argument returns true if none of the collection is a member of such class
# when a class is passed as an argument returns true if none of the collection is a member of such class::Numeric
# when a class is passed as an argument returns false if any of the collection is a member of such class
# when a Regex is passed as an argument returns true if none of the collection matches the Regex
# when a Regex is passed as an argument returns false if any of the collection matches the Regex
# when a pattern other than Regex or a Class is given returns true only if none of the collection matches the pattern
# when a pattern other than Regex or a Class is given returns false only if one of the collection matches the pattern
  def my_none?(args = nil)
    result = true
    if block_given?
      for i in self
        result = false if yield i
      end
    elsif !args.nil? && (args.is_a? Class)
      for i in self
        result = false if i.class == args
      end
    elsif !args.nil? && (args == Regexp)
      for i in self
        result = false if args.match(i)
      end
    elsif self.length == 1
      for i in self
        if i == nil
          result = true
        end
      end
    else
      for i in self
        result = false if i == args
      end
    end
    result
  end

  def my_count (args=nil)
    counter = 0
    if !block_given?
      if args.nil?
        for i in self
          counter+=1
        end
      else
        for i in self
          counter+=1 if i == args
        end
      end
    else
      for i in self
        if yield(i)
          counter +=1
        end
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
arr.my_any? {|num| num > 6}

p [nil].my_none?

ary = [1, 2, 4, 2]
p ary.my_count
p ary.my_count(2)
p ary.my_count{ |x| x%2==0 }
