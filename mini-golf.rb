# http://codegolf.stackexchange.com/questions/69716/code-mini-golf

require_relative 'harness.rb'

def test
  def assert(blah)
    raise "fail" if !blah
  end
  
  assert yield 1, 'U'

  s = %q"      ____       ____ _   
   __/    \     /    U \  
__/        \   /        \_
            \_/            "
  assert yield 27, s
  assert !(yield 26, s)

  s = %q"_/\                                         _
   \      __       /\/\/\                  / 
    \    /  \     /      \                /  
     \__/    \   /        \____________ _/   
              \_/                      U      "
  assert yield 16, s
end

solution(1) do
  ->i,s{s.lines.map(&:bytes).transpose.any?{|o|(c=o.max)==85||i<0||!(i+=c*3%14-6)};i>0}
end

run
