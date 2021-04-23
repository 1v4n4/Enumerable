# rubocop: disable Metrics/ModuleLength
# rubocop: disable Metrics/BlockNesting
# rubocop: disable Lint/UselessAssignment
# rubocop: disable Metrics/PerceivedComplexity
module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    # rubocop:disable Style/For
    for i in self
      yield(i)
    end
    self
  end
  # rubocop:enable Style/For

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    if instance_of?(Array)
      # rubocop:disable Style/For
      for i in self
        yield i, index(i)
      end
    elsif istance_of(Range) || instance_of?(Hash)
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
    elsif !args.nil? and (args.is_a? Class)
      for i in self
        result = false if i.class != args
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
    elsif !args.nil? && (args.is_a? Class)
      for i in self
        result = true if i.class.is_a?(args)
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
    elsif !args.nil? && args.is_a?(Class)
      for i in self
        result = false if i.class.is_a?(args)
      end
    elsif !args.nil? && (args == Regexp)
      for i in self
        result = false if args.match(i)
      end
    elsif length >= 1
      if length == 1 and self[0].nil?
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
  # rubocop: enable Style/For
  # rubocop: enable Metrics/ModuleLength
  # rubocop: enable Metrics/CyclomaticComplexity
  # rubocop: enable Metrics/MethodLength
  # rubocop: enable Metrics/BlockNesting
  # rubocop: enable Lint/UselessAssignment
  # rubocop: enable Metrics/PerceivedComplexity
end

def multiply_els(arr)
  arr.my_inject(1) { |multiply, num| multiply * num }
end
