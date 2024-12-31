# URL: https://adventofcode.com/2024/day/14

def part1
  state = evolve_robots(100)

  # Find robots in each quadrant.
  quadrants = {
    [0, Complex(($bounds.real - 1) / 2 - 1, ($bounds.imag - 1) / 2 - 1)] => 0,
    [Complex(0, ($bounds.imag - 1 ) / 2 + 1), Complex(($bounds.real - 1) / 2 - 1, $bounds.imag - 1)] => 0,
    [Complex(($bounds.real - 1) / 2 + 1, 0), Complex($bounds.real - 1, ($bounds.imag - 1) / 2 - 1)] => 0,
    [Complex(($bounds.real - 1) / 2 + 1, ($bounds.imag - 1) / 2 + 1), Complex(($bounds.real - 1), $bounds.imag - 1)] => 0
  }

  state.each do |pos|
    quadrants.keys.each do |quadrant|
      if quadrant[0].real <= pos.real and quadrant[0].imag <= pos.imag and quadrant[1].real >= pos.real and quadrant[1].imag >= pos.imag
        quadrants[quadrant] += 1
      end
    end
  end

  quadrants.values.inject(:*)
end

def part2
  iteration = nil

  evolve_robots(10000) do |state, n|
    overlapping = ! state.detect {|x| state.count(x) > 1 }.nil?
    next if overlapping

    iteration = n
    break

    # Print state.
    # (0...$bounds.imag).each do |y|
    #   (0...$bounds.real).each do |x|
    #     if state.include?(Complex(x, y))
    #       print "X"
    #     else
    #       print "."
    #     end
    #   end

    #   print "\n"
    # end
  end

  iteration
end

def evolve_robots(seconds=0)
  state = $robots.map{ |x| x[:initial_pos] }

  yield state, 0 if block_given?

  (0...seconds).each do |n|
    $robots.each_with_index do |robot, i|
      # Evolve robot based on velocity.
      new_pos = state[i] + $robots[i][:velocity]
      state[i] = Complex(new_pos.real % $bounds.real, new_pos.imag % $bounds.imag)
    end

    yield state, (n + 1) if block_given?
  end

  state
end

def parse_input
  re = /p=(?<x>\d+),(?<y>\d+) v=(?<vx>-?\d+),(?<vy>-?\d+)/
  $input.split("\n").map do |l|
    m = re.match(l)
    {:initial_pos => Complex(m['x'].to_i, m['y'].to_i), :velocity => Complex(m['vx'].to_i, m['vy'].to_i)}
  end
end

if __FILE__ == $0
  $input = File.read(__dir__ + '/input.txt')
  $robots = parse_input()
  $bounds = 101 + 103i

  p part1
  p part2
end
