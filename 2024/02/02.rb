# URL: https://adventofcode.com/2024/day/2

def part1
  $input.count(&method(:is_safe_level))
end

def part2
  $input.count do |level|
    variations = [level] + (0...level.length).map {|n| level[0, n] + level[n+1, level.length] }
    variations.any?(&method(:is_safe_level))
  end
end

def is_safe_level(level)
  pairs = level.each_cons(2)
  pairs.all? {|x,y| x < y and (y-x) <= 3 } or pairs.all? {|x,y| (x > y) and (x-y) <= 3 }
end

if __FILE__ == $0
  $input = File.readlines( __dir__ + '/input.txt').map {|x| x.strip.split(' ').map(&:to_i) }

  p part1
  p part2
end
