module Enumerable
  def my_each(&block)
    each(&block)
    self
  end

  def my_each_with_index
    each do |i|
      yield i, i - 1
    end
  end

  def my_select
    selected = []
    each do |i|
      selected.push(i) if yield(i)
    end
    selected
  end

  def my_all?
    result = true
    each do |i|
      result = false unless yield i
    end
    result
  end

  def my_any?
    result = false
    each do |i|
      result = true if yield i
    end
    result
  end

  def my_none?
    result = true
    each do |i|
      result = false if yield i
    end
    result
  end

  def my_count
    counter = 0
    each do |i|
      counter += 1 if yield(i)
    end
    counter
  end

  def my_map(proc = nil)
    mapped = []
    if proc
      each do |i|
        mapped.push(proc.call(i))
      end
    elsif block_given?
      each do |i|
        mapped.push(yield i)
      end
    end
    mapped
  end

  def my_inject(result = 0)
    my_each do |i|
      result = yield result, i
    end
    result
  end
end

def multiply_els(arr)
  arr.my_inject(1) { |multiply, num| multiply * num }
end
