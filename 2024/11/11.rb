# URL: https://adventofcode.com/2024/day/11

def part1
  $input.sum{|x| count_stone_descendants(x, 25) }
end

def part2
  $input.sum{|x| count_stone_descendants(x, 75) }
end

# We only care about the total number of stones, not what they look like, so there's no need to keep an array with
# everything. We also use a cache since descendants repeat.
$cache = {}
def count_stone_descendants(stone, no_steps)
  if no_steps == 0
    return 1
  end

  cache_key = "#{stone}:#{no_steps}"

  if ! $cache.key?(cache_key)
    if stone == 0
      result = count_stone_descendants(1, no_steps - 1)
    elsif stone.digits.length.even?
      digits = stone.digits.reverse
      left = digits.first(digits.length / 2).join.to_i
      right = digits.last(digits.length / 2).join.to_i
      result = count_stone_descendants(left, no_steps - 1) + count_stone_descendants(right, no_steps - 1)
    else
      result = count_stone_descendants(stone * 2024, no_steps - 1)
    end

    $cache[cache_key] = result
  end

  return $cache[cache_key]
end

if __FILE__ == $0
  $input = File.read( __dir__ + '/input.txt').split(' ').map(&:to_i)

  p part1
  p part2
end
