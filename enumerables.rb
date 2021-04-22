module Enumerables
  def my_each
    for i in self
      yield(i)
    end
    self
  end
