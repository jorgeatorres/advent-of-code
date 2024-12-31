# URL: https://adventofcode.com/2024/day/10

# Coords are (i, j) where i is row and j is column.
Coord = Struct.new(:i, :j)

def part1
  find_trails.each_value.map{|x| x.map(&:last).uniq.count}.sum
end

def part2
  find_trails.each_value.map(&:count).sum
end

def find_trail(h, path=[], all_paths=[])
  value = $input[h.i][h.j]

  if value == 9
    all_paths << path
    return
  end

  # Find all adjacent coords.
  adjacent = [ [h.i - 1, h.j], [h.i + 1, h.j], [h.i, h.j - 1], [h.i, h.j + 1] ]
    .filter_map{|i, j| Coord.new(i, j) if i >= 0 and j >= 0 and i < $input.length and j < $input.length }
    .filter_map{|t| t if $input[t.i][t.j] == value + 1 }

  adjacent.each do |next_head|
    find_trail(next_head, path + [next_head], all_paths)
  end
end

def find_trails
  trailheads = (0...$input.length).to_a.product((0...$input.length).to_a).filter_map {|i,j| Coord.new(i, j) if $input[i][j] == 0 }
  trailheads.to_h do |th|
    all_paths = []
    find_trail(th, [th], all_paths)
    [th, all_paths]
  end
end

def all_trailheads
  (0...$input.length).to_a.product((0...$input.length).to_a).filter_map {|i,j| Coord.new(i, j) if $input[i][j] == 0 }
end

if __FILE__ == $0
  $input = File.read( __dir__ + '/input.txt').split.map(&:chars).map{|x| x.map(&:to_i) }

  p part1
  p part2
end
