# URL: https://adventofcode.com/2024/day/1

def part1
  pairs = $input.map(&:first).sort.zip($input.map(&:last).sort)
  pairs.map {|x,y| (x-y).abs }.sum
end

def part2
  col1 = $input.map(&:first)
  col2 = $input.map(&:last)

  col1.map { |x| x * col2.count(x) }.sum
end

if __FILE__ == $0
  $input = File.readlines( __dir__ + '/input.txt').map {|x| x.strip.split(' ').map(&:to_i)}

  p part1
  p part2
end
