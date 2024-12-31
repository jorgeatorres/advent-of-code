# URL: https://adventofcode.com/2024/day/21

# I initially didn't understand why there would be 'shortest sequences' as all possible combos on the first pad (the
# numeric pad) are the same length (distance between numbers is just taxicab distance).
# From there on I thought it was just a matter of finding _a sequence_ on the higher order keypads that would produce
# the string from the first one.
#
# After a failing example I understood that while that's true for the first pad, some specific moves on the numeric pad
# become easier or harder on the higher order keypads.
# For example while "<<vv" and "<v<v" are exactly the same 'cost' on the numeric pad, they are different cost for the
# directional path. The first takes "v<<AA>AA" while the other takes "v<<A>A<A>A".
#
# So we should prioritize paths that are more 'straight', and, in any case, the cost of a given path actually depends
# on the higher order keypads.
#
# I thought we could just brute-force this. As in, 'find all possible combos on the numeric pad' and then all combos
# on the higher order directional pads that would produce each of those initial combos, and so on, and then just keep
# the shortest.
# While that could've worked for the first part, it wouldn't work for the second.

def part1
  $input.map{ |code| code.to_i * cost(code, 3) }.sum
end

def part2
  $input.map{ |code| code.to_i * cost(code, 26) }.sum
end

def pads()
  numeric = ' 0A123456789'.chars.map.with_index{ |x,i| [x, (i % 3) + (3 - i/3)*1i ] }.to_h
  directional = '<v> ^A'.chars.map.with_index{ |x, i| [x, (i % 3) + (1 - i/3)*1i]  }.to_h
  [numeric, directional]
end

def find_path(start, goal)
  $cache = Hash.new({}) if $cache.nil?
  cache_key = [start, goal]

  if ! $cache[__method__].key?(cache_key)
    pad = pads().find { |x| x.include?(start) && x.include?(goal) }
    diff = pad[goal] - pad[start]
    dx, dy = diff.real, diff.imag

    path_x = (dx > 0 ? '>' : '<') * dx.abs
    path_y = (dy > 0 ? 'v' : '^') * dy.abs

    # We need to avoid the gap.
    gap = pad[' ']
    through_gap_x = (pad[start].real + dx == gap.real) && pad[start].imag == 0
    through_gap_y = (pad[start].imag + dy == gap.imag) && pad[start].real == 0

    gap = pad[' '] - pad[start]
    do_y_first = (dx > 0 || gap == dx) && gap != dy * 1i

    # if do_y_first != through_gap_x
    #   p do_y_first, through_gap_x, start, goal
    #   exit
    # end

    # do_y_first = through_gap_x

    $cache[__method__][cache_key] = do_y_first ? "#{path_y}#{path_x}A" : "#{path_x}#{path_y}A"
  end

  $cache[__method__][cache_key]
end

def cost(code, level, s=0)
  $cache = Hash.new({}) if $cache.nil?
  cache_key = [code, level, s]

  return code.length if level == 0

  if ! $cache[__method__].key?(cache_key)
    code.chars.each_with_index do |c, i|
      s += cost(find_path(code[i - 1], c), level - 1)
    end

    $cache[__method__][cache_key] = s
  end

  $cache[__method__][cache_key]
end


if __FILE__ == $0
  $input = File.readlines(__dir__ + '/input.txt', chomp: true)

  p part1
  p part2
end
