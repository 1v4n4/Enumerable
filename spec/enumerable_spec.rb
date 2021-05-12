require_relative '../enumerable.rb'

describe Enumerable do

  let(:arr) {[1,2,3,4,5]}
  let(:hash) {{one: "first", two: "second", three: "third", four: "fourth", five: "fifth"}}
  let(:arr_nill) {[nil, 1, 2, 3, 4, 5]}
  let(:arr_false) {[1,2,3,4,5,false]}

  describe '#my_each' do

    it "returns an enumerator if no block given" do
      expect(arr.my_each).to be_a(Enumerator)
    end

    it "iterate over the array, and updates new array" do
      new_variable = Array.new
      arr.my_each { |x| new_variable << x*2 }
      expect(new_variable).to eq([2,4,6,8,10])
    end

    it "iterate over the array, but returns the same array" do
      expect(arr.my_each { |x| x*2}).to eql arr
    end
  end

  describe 'my_each_with_index' do

    it 'calls block with two arguments, the item and its index, iterate over argument and update new variable' do
      new_variable = Array.new
      arr.my_each_with_index {|x, index| new_variable << x*2}
      expect(new_variable).to eql([2,4,6,8,10])
    end

    it "returns enumerator if no block given" do
      expect(hash.my_each_with_index).to be_a(Enumerator)
    end

    it 'calls block with two arguments, the item and its index, iterate over argument and return same argument' do
      expect(arr.my_each_with_index { |x, index| x*2 if index.odd? }).to eql arr
    end

  end

  describe '#my_inject' do

    it 'raises LocalJumpError if no block or proc given' do
      expect { arr.my_inject }.to raise_error(LocalJumpError)
    end

    it 'if block given, for each element is passed to an accumulator value, which is returned' do
      expect(arr.my_inject {|acc, x| acc+x*2}).to eql(29)
    end

    it 'works with initialized value of accumulator' do
      expect(arr.my_inject(20) {|acc, x| acc+x*2}).to eql(50)
    end

    it 'if symbol specified, each element in the collection will be passed to the named method of accumulator' do
     expect(arr.my_inject(:+)).to eql(15)
    end

    it 'works with symbol specified, and initialized value of accumulator' do
     expect(arr.my_inject(20,:+)).to eql(35)
    end
   end
end
