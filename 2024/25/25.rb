# URL: https://adventofcode.com/2024/day/25

def part1
  # Compute heights.
  locks, keys = parse_input().map do |s|
    s.map do |key_or_lock|
      key_or_lock.map(&:chars).transpose.map {|l| l.count('#') - 1 }
    end
  end

  # Try every key with every lock.
  locks
    .product(keys)
    .filter do |key_and_lock|
      key_and_lock.transpose.map(&:sum).max <= 5
    end
    .length
end

def parse_input()
  keys = []
  locks = []

  File.readlines(__dir__ + '/input.txt', chomp: true)
    .reject(&:empty?)
    .each_slice(7) do |key_or_lock|
      # p key_or_lock
      locks << key_or_lock if key_or_lock[0] == '#' * 5
      keys << key_or_lock if key_or_lock[6] == '#' * 5
    end

  [locks, keys]
end

if __FILE__ == $0
  p part1
end
