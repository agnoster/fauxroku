module Enumerable
  def find_with_result(*args)
    result = nil
    detect(*args) do |i|
      result = yield i
    end
    result
  end
end
