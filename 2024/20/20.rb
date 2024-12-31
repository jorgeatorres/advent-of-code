# URL: https://adventofcode.com/2024/day/20

def part1
  grid = $input.dup

  # There's only one possible path. Let's just find it.
  distances, path = find_path(grid, grid.key('S'), grid.key('E'))

  # For each point in the path, let's check whether removing 'nearby' blocks would result in a substantial reduction in
  # path length. Removing blocks is only useful if they lead back to the path (otherwise they actualy make the path longer),
  # and thus we can directly check which "jumps" (as in teleportation) between a point and another point in the path
  # produce the reduction we want.
  # We could iterate over each point or consider all possible pairs.
  # As for which other points to consider at a given point, we only care about those that are at exactly a Manhattan distance of 2.
  # Eliminating blocks further away doesn't change path length as we still need to get there and by the time we do it
  # the 2 pico-seconds have elapsed, so the blocks are back.
  distances
    .to_a
    .combination(2)
    .filter_map do |(x1, d1), (x2, d2)|
      taxicab = (x1 - x2).real.abs + (x1 - x2).imag.abs
      d2 - d1 - taxicab if taxicab == 2
    end
    .filter{ |d| d >= 100 }
    .length
end

# Super slow, but works.
def part2
  grid = $input.dup

  # There's only one possible path. Let's just find it.
  distances, path = find_path(grid, grid.key('S'), grid.key('E'))

  distances
    .to_a
    .combination(2)
    .filter_map do |(x1, d1), (x2, d2)|
      taxicab = (x1 - x2).real.abs + (x1 - x2).imag.abs
      d2 - d1 - taxicab if taxicab <= 20
    end
    .filter{ |d| d >= 100 }
    .length
end

def find_path(grid, start, finish)
  dist = {start => 0}
  q = [start]

  until q.empty?
    e = q.pop

    [1, -1, 1i, -1i].each do |dir|
      c = e + dir

      if grid.include?(c) and ! dist.include?(c)
        dist[c] = dist[e] + 1
        q << c
      end
    end
  end

  [dist, dist.keys]
end

def parse_input(input)
  grid = Hash.new('#')
  grid.merge(input.split("\n").map.with_index{ |l, y| l.chars.filter_map.with_index { |c, x| [x + 1i*y, c] if c != '#'  } }.flatten(1).to_h)
end

if __FILE__ == $0
  $input = parse_input(File.read(__dir__ + '/input.txt'))

  p part1
  p part2
end
