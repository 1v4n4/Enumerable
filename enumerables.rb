
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
  return to_enum(:my_map) unless block_given?
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
        if acc.nil?
          acc = i
        else
          acc = acc.send(init, i)
        end
      end
      acc
    elsif sym.is_a?(Symbol) && init.is_a?(Integer)
      acc = init
      to_a.my_each do |i|
        acc = acc.send(sym, i)
      end
      acc
    else
      my_each do |i|
        acc = yield acc, i
      end
    end
    acc
  end
end

def multiply_els(arr)
  arr.my_inject(1) { |multiply, num| multiply * num }
end
