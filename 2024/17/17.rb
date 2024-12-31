# URL: https://adventofcode.com/2024/day/17

def part1()
  a, b, c, *code = $input.scan(/\d+/).map(&:to_i)

  program = Program.new(code, a, b, c)
  program.run()
  program.output.join(',')
end

def part2()
  # Looking at my input, the last instruction is 3 0, which means the pointer moves to the first
  # instruction _unless_ the A register is zero.
  # There is also only one output instruction and no other jnz instruction, which means
  # the output is the result of a loop that executes 16 times (to print each digit in the program).
  # Now, rewriting the instructions as "code" we have this:
  #
  # while A
  #   B = A % 8
  #   B = B ^ 1
  #   C = A >> B # A / 2^B
  #   A = A >> 3 # A / 8
  #   B = B ^ C
  #   B = B ^ 6
  #   print B % 8
  # end
  #
  # At each iteration, register A is set to A / 8 and the last iteration must end at A = 0, otherwise the loop wouldn't
  # end. This means there are A(0), A(1), ..., A(15)=0 values that the A register might hold and we're interested in
  # A(0).
  # Notice that A(n+1) = A(n) / 8, where the division is integer, not exact. For example, A(15) = 0 means A(14) is
  # between 0 and 7 (otherwise the division is not zero). Similarly, A(13) = 8*A(14) + j where j = 0, ..., 7. And so on.
  # Thus we can search for A's by guessing A(15) and running the possible programs. They would stop after one iteration
  # and print what we expect to be the last digit in the program.
  # Once we've found A(14), we do the same but now we  that would produce the last 0 in the output, and run those
  # programs to see if they also produce the output from the second to last to last digits, and so on.

  _, b, c, *code = $input.scan(/\d+/).map(&:to_i)

  index = code.length - 1
  possible_as = [0]

  while index >= 0 do
    queue = []

    possible_as.each do |a|
      (0..7).each do |n|
        new_a = a * 8 + n

        program = Program.new(code, new_a, b, c)
        program.run

        queue << new_a if program.output == code[index, code.length]
      end
    end

    index -= 1
    possible_as = queue
  end

  possible_as.min
end

class Program
  attr_reader :output, :code

  def initialize(code, a=0, b=0, c=0)
    @code = code
    @ptr = 0
    @output = []

    # Registers
    @a = a
    @b = b
    @c = c
  end

  def run()
    until @ptr >= @code.length do
      instruction, arg = @code[@ptr], @code[@ptr + 1]
      combo = {0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => @a, 5 => @b, 6 => @c}

      case @code[@ptr, 2]
      in 1, arg then @b = @b ^ arg
      in 0, arg then @a = @a / ( 2 ** combo[arg] )
      in 2, arg then @b = combo[arg] % 8
      in 3, arg then @ptr = @a != 0 ? arg - 2 : @ptr
      in 4, _ then @b = @b ^ @c
      in 5, arg then @output << combo[arg] % 8
      in 6, arg then @b = @a / (2 ** combo[arg])
      in 7, arg then @c = @a / (2 ** combo[arg])
      end

      # Move on.
      @ptr += 2
    end
  end

end

if __FILE__ == $0
  $input = File.read(__dir__ + '/input.txt')

  p part1
  p part2
end
