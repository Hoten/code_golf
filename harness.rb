require 'sourcify' # gem install sourcify --pre | see https://github.com/ngty/sourcify/issues/26

@solutions = {}

def latest_solution
  @solutions[@solutions.keys.sort.last]
end

def solution_source(solution)
  solution.to_raw_source.lines[1..-2].map(&:strip).join("\n")
end

def solution(version, &block)
  @solutions[version.to_s] = block
end

# this will return the output of a solution
# captures stdout because I want to keep the block methods pure
# as in, the code inside a solution block should be a standalone program
# this requires it to print to stdout
def run_solution(solution, *args)
  temp_stdout = StringIO.new
  $stdout = temp_stdout
  result = solution.call

  if result.class == Proc
    result = result.call(*args)
  else
    result = temp_stdout.string
  end

  $stdout = STDOUT

  result
end

def run
  command = ARGV[0] || 'run'
  solution = ARGV[1] ? @solutions[ARGV[1]] : latest_solution

  if command == 'test'
    test do |*args|
      run_solution(solution, *args)
    end
    puts 'correct'
  elsif command == 'score'
    if ARGV[1] == 'all'
      @solutions.each { |version, solution|
        score = solution_source(solution).length
        puts "#{version}: #{score}"
      }
    else
      puts solution_source(solution).length
    end
  elsif command == 'run'
    solution.call
  end
end
