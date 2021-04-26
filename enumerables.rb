# rubocop: disable Metrics/ModuleLength
# rubocop: disable Metrics/BlockNesting
# rubocop: disable Lint/UselessAssignment
# rubocop: disable Metrics/PerceivedComplexity
# rubocop: disable Style/For
module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    for i in self
      yield(i)
    end
    self
  end

  def my_each_with_index    return enum_for unless block_given?
    idx = 0
    arr ||= to_a    while idx < arr.length      yield(arr[idx], idx)      idx += 1    end
    self  end

  def my_each_with_index
    # rubocop: disable Layout/TrailingWhitespace 
    return to_enum(:my_each_with_index) unless block_given?
    
    # rubocop: enable Layout/TrailingWhitespace
    if is_a?(Array)
      for i in self
        yield i, index(i)
      end
    elsif is_a?(Range) || is_a?(Hash)
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

  # rubocop: disable Metrics/CyclomaticComplexity
  # rubocop: disable Metrics/MethodLength
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
    elsif args.is_a?(Class)
      for i in self
        result = false if !(i.is_a?(args))
      end
    elsif !args.nil? and (args.is_a? Regexp)
      for i in self
        result = false unless args.match(i)
      end
    else
      for i in self
        result = false if i != args
      end
    end
    result
  end

  def my_any?(args = nil)
    result = false
    if block_given?
      for i in self
        result = true if yield i
      end
    elsif args.is_a?(Class)
      for i in self
        result = true if i.is_a?(args)
      end
    elsif args.is_a?(Regexp)
      for i in self
        if i.match(args)
          result = true
        end
      end
    elsif !block_given? && args == nil
      for i in self
        return false if i.nil? || i == false
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
    elsif args.is_a?(Class)
      for i in self
        result = false if i.is_a?(args)
      end
    elsif args.is_a?(Regexp)
      for i in self
        result = false if i.match(args)
      end
    elsif length >= 1
      if length == 1 and self[0].nil?
        result = true
      else
        for i in self
          result = false if i == true
        end
      end
    elsif !(args.is_a?(Regexp)) && !(args.is_a?(Class))
      for i in self
        result = false if i == args
      end
    else
      for i in self
        result = false if i == args
      end
    end
    result
  end

  def my_count(args = nil)
    counter = 0
    if block_given?
      for i in self
        counter += 1 if yield(i)
      end
    else
      # rubocop: disable Style/IfInsideElse
      if args.nil?
        for i in self
          counter += 1
        end
      else
        for i in self
          counter += 1 if i == args
        end
      end
      # rubocop: enable Style/IfInsideElse
    end
    counter
  end

  def my_map(proc = nil)
    # rubocop: disable Lint/ToEnumArguments
    return to_enum(:my_map) unless block_given?
    # rubocop: enable Lint/ToEnumArguments

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

  def my_inject(init = nil, sym = nil)
    if block_given?
      acc = init
      # rubocop:disable Style/ConditionalAssignment
      to_a.my_each do |i|
        if acc.nil?
          acc = i
        else
          acc = yield(acc, i)
        end
      end
      acc
    elsif init.is_a?(Symbol)
      acc = nil
      to_a.my_each do |i|
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
  # rubocop: enable Style/ConditionalAssignment
  # rubocop: enable Metrics/ModuleLength
  # rubocop: enable Metrics/CyclomaticComplexity
  # rubocop: enable Metrics/MethodLength
  # rubocop: enable Metrics/BlockNesting
  # rubocop: enable Lint/UselessAssignment
  # rubocop: enable Style/For
  # rubocop: enable Metrics/PerceivedComplexity
end

def multiply_els(arr)
  arr.my_inject(1) { |multiply, num| multiply * num }
end

some_array = [1,2,3,4, "Lol"]

p %w{ant bear cat}.my_none? { |word| word.length == 5 } #=> true
p %w{ant bear cat}.my_none? { |word| word.length >= 4 } #=> false
p %w{ant bear cat}.my_none?(/d/)                        #=> true
p [1, 3.14, 42].my_none?(Float)                         #=> false
p [].my_none?                                           #=> true
p [nil].my_none?                                        #=> true
p [nil, false].my_none?                                 #=> true
p [nil, false, true].my_none?                           #=> false