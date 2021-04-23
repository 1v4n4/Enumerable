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

  def my_none?(args = nil)
    result = true
    if block_given?
      for i in self
        result = false if yield i
      end
    elsif !args.nil? && (args.is_a?(Class))
      for i in self
        result = false if i.class == args
      end
    elsif !args.nil? && (args == Regexp)
      for i in self
        result = false if args.match(i)
      end
    elsif self.length >= 1
      if self.length == 1 and self[0] == nil
        result = true
      else
        for i in self
          result = false if i == true 
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

#   searches for the longest word in an array of strings
#  when a block is given without an initial value combines all elements of enum by applying a binary operation, specified by a block::range
#  when a symbol is specified without an initial value combines each element of the collection by applying the symbol as a named method
#  when a symbol is specified without an initial value combines each element of the collection by applying the symbol as a named method:range
#  when a symbol is specified with an initial value combines each element of the collection by applying the symbol as a named method
#  when a symbol is specified with an initial value combines each element of the collection by applying the symbol as a named method::range
  def my_inject (init = nil, sym = nil)
    if block_given?
      acc = init
      self.to_a.my_each do |i|
        if !acc.nil?
          acc = yield(acc, i)
        else
          acc = i
        end
      end
      acc
    elsif init.is_a?(Symbol)
      acc = nil
      self.to_a.my_each do |i|
        if !acc.nil?
          acc = acc.send(init, i)
        else
          acc = i
        end
      end
      acc
    elsif (sym.is_a?(Symbol) && init.is_a?(Integer)) 
      acc = init
      self.to_a.my_each do |i|
        acc = acc.send(sym, i)
      end
      acc
    else
      self.my_each do |i|
        acc = yield acc, i
      end
    end
    acc
  end

end

def multiply_els(ar)
  ar.my_inject(1) {|multiply, num| multiply * num}
end

arr = [3, 4, 6, 2]
arr.my_any? {|num| num > 6}

# longest = %w{ cat sheep bear }.inject do |memo, word|
#   memo.length > word.length ? memo : word
# end

# puts longest

p (5..10).my_inject(:+)
p (5..10).my_inject { |sum, n| sum + n }
p (5..10).my_inject(1, :*)
p (5..10).my_inject(1) { |product, n| product * n }
sentences = ["The ice cream truck is rolling on by", "There is a dog in the park", "There are jumping lizards on the fountain", "Why is there no rain today? I brought an umbrella for nothing.", "There is a dog park nearby!"]
p sentences.inject{ |memo, sentence| memo.size < sentence.size ? memo = sentence : memo}
