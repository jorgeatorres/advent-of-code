# URL: https://adventofcode.com/2024/day/8

def part1
  # For part 1, points X and Y that are antinodes have to be at a distance A2-A1 from A1 and A2 resp, and so
  # satisfy equations (A1-X) = (A2-A1) and (Y-A2)=(A2-A1).
  calculate_antinodes do |antenna1, antenna2, bounds|
    [2 * antenna1 - antenna2, 2 * antenna2 - antenna1].filter{ |p| p.real >=0 and p.imag >=0 and p.real < bounds.real and p.imag < bounds.imag }
  end
end

def part2
  # For part 2, an antinode X only has to be aligned with A1 and A2. That is, it has to be an integer multiple of
  # B-A.
  calculate_antinodes do |antenna1, antenna2, bounds|
    antinodes = []
    delta = antenna2 - antenna1

    # Approach the origin from A1 and expand out from A2.
    [antenna1, antenna2].each_with_index do |a, i|
      p = a

      loop do
        break unless p.real >= 0 and p.imag >= 0 and p.real < bounds.real and p.imag < bounds.imag
        antinodes << p
        p = p + delta * ( (-1) ** i )
      end
    end

    antinodes
  end
end

def calculate_antinodes(&antinode_generator)
  bounds = Complex($input[0].length, $input.length)

  # Gather antennas by frequency.
  antennas = {}
  $input.each_with_index do |row, y|
    row.each_with_index do |e, x|
      next if e == '.'
      antennas[e] = antennas.fetch(e, []) + [Complex(x, y)]
    end
  end

  # For each pair of possible antennas calculate all antinodes.
  antinodes = []
  antennas.each do |freq, positions|
    positions.combination(2) do |antenna1, antenna2|
      antinodes += antinode_generator.call(antenna1, antenna2, bounds)
    end
  end

  antinodes.uniq.count
end

if __FILE__ == $0
  $input = File.read( __dir__ + '/input.txt').split.map(&:chars)

  p part1
  p part2
end
