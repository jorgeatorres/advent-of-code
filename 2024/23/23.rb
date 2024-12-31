# URL: https://adventofcode.com/2024/day/23

def part1
  $nodes.keys
    .inject([]) {|memo, computer| memo + find_lan($nodes, [computer], 3) }
    .uniq
    .filter {|network| network.length == 3 }
    .filter {|network| network.any?{ |computer| computer[0] == 't' } }
    .length
end

def find_lan(nodes, so_far, max_size=nil)
  @cache = {} if @cache.nil?

  so_far = so_far.sort

  if @cache.key?(so_far)
    return @cache[so_far]
  end

  result = []
  result << so_far.sort

  if max_size.nil? or (so_far.length < max_size)
    adjacent = nodes[so_far[-1]].difference(so_far)
    adjacent.each do |c|
      next if so_far.include?(c) or ! so_far.difference(nodes[c]).empty?
      result += find_lan(nodes, so_far + [c], max_size)
    end
  end

  @cache[so_far] = result.uniq
  @cache[so_far]
end

def part2
  @cache = nil # Reset cache.
  $nodes.keys
    .inject([]) {|memo, computer| memo + find_lan($nodes, [computer]) }
    .sort_by {|x| x.length  }
    .last
    .join(',')
end

def parse_input(input)
  computers = Hash.new([])

  input.each do |line|
    c1, c2 = line.split('-')
    computers[c1] = computers[c1] + [c2]
    computers[c2] = computers[c2] + [c1]
  end

  computers
end

if __FILE__ == $0
  $nodes = parse_input(File.readlines(__dir__ + '/input.txt', chomp: true))

  p part1
  p part2
end
