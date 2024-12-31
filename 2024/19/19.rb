# URL: https://adventofcode.com/2024/day/19

def part1
  patterns, *designs = $input
  designs.map {|x| count_ways(x, patterns) }.count {|x| x > 0 }
end

def part2
  patterns, *designs = $input
  designs.map {|x| count_ways(x, patterns) }.sum
end

# Count ways a towel could be made from patterns.
def count_ways(towel, patterns)
  # Use cache for better performance.
  $cache = {} if $cache.nil?

  if towel.empty?
    return 0
  end

  if ! $cache.key?(towel)
    cnt = 0
    patterns.each do |p|
      if p == towel
        cnt += 1
      elsif towel.start_with?(p)
        cnt += count_ways(towel[p.length...], patterns)
      end
    end

    $cache[towel] = cnt
  end

  $cache[towel]
end

if __FILE__ == $0
  $input = File
    .readlines(__dir__ + '/input.txt', chomp: true)
    .map{|l| l.include?(',') ? l.split(',').map(&:strip) : l }
    .compact

  p part1
  p part2
end
