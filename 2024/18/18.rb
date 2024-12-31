# URL: https://adventofcode.com/2024/day/18

def part1
  find_path($input.slice(0, 1024), 70)
end

def part2
  # Not every efficient but ¯\_(ツ)_/¯
  corrupted = $input[0...1024]

  n = 1024
  $input[1024...].each do |p|
    n += 1
    corrupted << p

    if find_path(corrupted, 70).nil?
      return [p.real, p.imag].join(',')
    end
  end
end

def find_path(corrupted, grid_size=70)
  the_start = 0 + 0i
  the_exit = grid_size + 1i*grid_size

  distances = []

  q = []
  q << [the_start, 0] # <pos, dist>

  seen = []
  seen << the_start

  until q.empty?
    pos, dist = q.shift()

    neighbors = [1, -1, 1i, -1i]
      .map {|d| pos + d }
      .reject {|p| p.real < 0 or p.imag < 0 or p.real > grid_size or p.imag > grid_size or corrupted.include?(p) }
      .reject {|p| seen.include?(p) }

    neighbors.each do |n|
      if n == the_exit
        distances << dist + 1
      else
        seen << n
        q << [n, dist + 1]
      end
    end
  end

  distances.min
end


if __FILE__ == $0
  $input = File.read(__dir__ + '/input.txt')
    .split("\n")
    .map{|l| l.split(',').map(&:to_i) }
    .map{|x, y| x + 1i*y }

  p part1
  p part2
end
