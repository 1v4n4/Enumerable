require_relative '../enumerable'

describe Enumerable do
  let(:arr) { [1, 2, 3, 4, 5] }
  let(:hash) { { one: 'first', two: 'second', three: 'third', four: 'fourth', five: 'fifth' } }
  let(:arr_nil) { [nil, 1, 2, 3, 4, 5] }
  let(:arr_false) { [1, 2, 3, 4, 5, false] }
  let(:arr_string) { %w[one two three four five] }
  let(:arr_none) { [false, nil, false, nil, false] }

  describe '#my_each' do
    it 'returns an enumerator if no block given' do
      expect(arr.my_each).to be_a(Enumerator)
    end

    it 'iterate over the array, and updates new array' do
      new_variable = []
      arr.my_each { |x| new_variable << x * 2 }
      expect(new_variable).to eq([2, 4, 6, 8, 10])
    end

    it 'iterate over the array, but returns the same array' do
      expect(arr.my_each { |x| x * 2 }).to eql arr
    end
  end

  describe 'my_each_with_index' do
    it 'calls block with two arguments, the item and its index, iterate over argument and update new variable' do
      new_variable = []
      arr.my_each_with_index { |x, _index| new_variable << x * 2 }
      expect(new_variable).to eql([2, 4, 6, 8, 10])
    end

    it 'returns enumerator if no block given' do
      expect(hash.my_each_with_index).to be_a(Enumerator)
    end

    it 'calls block with two arguments, the item and its index, iterate over argument and return same argument' do
      expect(arr.my_each_with_index { |x, index| x * 2 if index.odd? }).to eql arr
    end
  end

  describe '#my_select' do
    it 'returns enumerator if no block given' do
      expect(hash.my_select).to be_a(Enumerator)
    end

    it 'returns an array of elements for which the given block returns a true value' do
      expect(arr.my_select { |x| x < 4 }).to eql([1, 2, 3])
      expect(hash.my_select { |_k, v| %w[second fifth].include?(v) }).to be_a(Array)
    end
  end

  describe '#my_all?' do
    it 'passes each element of the collection to the block and returns true if never get false or nil' do
      expect(arr.my_all? { |x| x < 100 }).to be true
    end

    it "passes each element of the collection to the block and returns false if doesn't get a true value" do
      expect(arr.my_all? { |x| x % 2.positive? }).to be false
    end

    it 'if block not given, returns true when none of the collection members are false or nil' do
      expect(arr.my_all?).to be true
    end

    it 'if block not given, returns false when at least one of the collection members are false or nil' do
      expect(arr_nil.my_all?).to be false
      expect(arr_false.my_all?).to be false
    end

    it 'if pattern supplied, returns true if pattern equals each element of collection' do
      expect(arr_string.my_all?(/t/)).to be false
    end

    it 'if regex given, returns false  if it is different to at least one element of collection' do
      expect(arr_string.my_all?(/[a-z]/)).to be true
    end

    it 'if class is passed as an argument returns true if all of the collection is a member of such class' do
      expect(arr_string.my_all?(String)).to be true
    end

    it 'if class passed, returns false if at least one of the collection is not a member of such class' do
      expect(arr_nil.my_all?(Integer)).to be false
    end
  end

  describe '#my_any?' do
    it 'passes each element of the collection to the given block and returns true if gets true value' do
      expect(arr.my_any? { |x| x == 1 }).to be true
    end

    it 'passes each element of the collection to the given block and returns false if gets all false or nil values' do
      expect(arr.my_any? { |x| x == 10 }).to be false
    end

    it 'if block not given returns true if at least one of the collection members is not false or nil' do
      expect(arr_nil.my_any?).to be true
    end

    it 'if block not given returns false if all collection members are false or nil' do
      expect(arr_none.my_any?).to be false
    end

    it 'if pattern supplied, returns true if pattern equals at least one element in a collection' do
      expect(arr_string.my_any?(/t/)).to be true
    end

    it 'if regex given, returns false if it is not equal to any element in a collection' do
      expect(arr_string.my_any?(/[0-9]/)).to be false
    end

    it 'if class is passed as an argument returns true if at least one of the collection is a member of such class' do
      expect(arr_nil.my_any?(Integer)).to be true
    end

    it 'if class is passed as an argument returns false if none of the collection is a member of such class' do
      expect(arr_string.my_any?(Integer)).to be false
    end
  end

  describe '#my_none?' do
    it 'passes elements of the collection to the block and returns true if the block never returns true' do
      expect(arr_string.my_none? { |x| x.instance_of?(Integer) }).to be true
    end

    it 'passes elements of the collection to the block and returns false if the block returns true' do
      expect(arr.my_none? { |x| x == 1 }).to be false
    end

    it 'if block not given, returns true if none of the collection members is true' do
      expect(arr_none.my_none?).to be true
    end

    it 'if block not given, returns false if at least one of the collection members is true' do
      expect(arr_false.my_none?).to be false
    end

    it "if pattern supplied, the returns true if none of collection's members matches pattern" do
      expect(arr_string.my_none?(/t/)).to be false
    end

    it "if regex supplied, the returns true if none of collection's members matches it" do
      expect(arr_string.my_none?(/[0-9]/)).to be true
    end

    it 'if class is passed as an argument returns true if none of the collection is a member of such class' do
      expect(arr_none.my_none?(Integer)).to be true
    end

    it 'if class passed, returns false if no element in collection is a member of such class' do
      expect(arr_nil.my_none?(Integer)).to be false
    end
  end

  describe '#my_count' do
    it 'returns a number of elements in collection, if no argument or block given' do
      expect(arr.my_count).to eql(5)
    end

    it 'if argument is given, returns the number of items in collection that are equal argument' do
      expect(arr.my_count(4)).to eql(1)
    end

    it 'if block is given, counts the number of elements yielding a true value' do
      expect(arr.my_count { |x| x % 2.positive? }).to be(3)
    end
  end

  describe '#my_map' do
    it 'returns a new array with the results of running block for every element in collection, if block given' do
      expect(arr.my_map { |x| x * 2 }).to eql([2, 4, 6, 8, 10])
    end

    it 'if proc given, returns a new array with the results of running proc for every element in collection' do
      expect(arr.my_map(proc { |x| x * 2 })).to eql([2, 4, 6, 8, 10])
      expect(arr.my_map(&:to_s)).to eql(%w[1 2 3 4 5])
    end

    it 'if no block or proc is given, returns an enumerator' do
      expect(arr.my_map).to be_a(Enumerator)
    end
  end

  describe '#my_inject' do
    it 'raises LocalJumpError if no block or proc given' do
      expect { arr.my_inject }.to raise_error(LocalJumpError)
    end

    it 'if block given, for each element is passed to an accumulator value, which is returned' do
      expect(arr.my_inject { |acc, x| acc + x * 2 }).to eql(29)
    end

    it 'works with initialized value of accumulator' do
      expect(arr.my_inject(20) { |acc, x| acc + x * 2 }).to eql(50)
    end

    it 'if symbol specified, each element in the collection will be passed to the named method of accumulator' do
      expect(arr.my_inject(:+)).to eql(15)
    end

    it 'works with symbol specified, and initialized value of accumulator' do
      expect(arr.my_inject(20, :+)).to eql(35)
    end
  end

  describe '#multiply_els' do
    it 'multiplies all values of the argument, and returns result' do
      expect(multiply_els(arr)).to eql(120)
    end
  end
end
