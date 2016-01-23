# http://codegolf.stackexchange.com/questions/69889/bouncing-in-an-array

require_relative 'harness.rb'

def test
  def assert_equal(a, b)
    raise "expected #{a} but got #{b}" if a != b
  end

  assert_equal [[1, 7, 3, 9, 5], [6, 2, 8, 4, 0]], (yield [1, 2, 3, 4, 5], [6, 7, 8, 9, 0])
  assert_equal [[1, 2, 3, 4, 5]], (yield [1, 2, 3, 4, 5])
  assert_equal [[0, 9, 0, 9, 0, 9, 0, 100], [9, 0, 9, 0, 9, 0, 9, 0], [0, 9, 0, 9, 0, 9, 0, 100]], (yield [0, 0, 0, 0, 0, 0, 0, 0], [9, 9, 9, 9, 9, 9, 9, 100], [0, 0, 0, 0, 0, 0, 0, 0])
end

solution(1) do
  ->*a{b=a.length;b<2?a:b.times.map{|i|d=i>0?-1:1;c=i;a[0].length.times.map{|j|r=a[c][j];c+=d;d*=-1if c==0||c==a.length-1;r}}}
end

run
