# URL: https://adventofcode.com/2024/day/22

def part1
  $input
    .map do |number|
      (0...2000).inject(number) {|r| secret_number(r) }
    end
    .sum
end

def part2
  sold_by_sequence = Hash.new(0)

  $input
    .each do |number|
      seen = Hash.new(false)
      list = buyer_sequence(number, 2000)

      (4...list.length).each do |i|
        seq = list.values_at((i - 3)..i).map(&:last)
        next if seen.key?(seq)
        sold_by_sequence[seq] += list[i][1]
        seen[seq] = true
      end
    end

  sold_by_sequence.values.max
end

def secret_number(n)
  n = (n * 64) ^ n
  n = n % 16777216
  n = (n / 32) ^ n
  n = n % 16777216
  n = (n * 2048) ^ n
  n = n % 16777216
  n
end

def buyer_sequence(starting_n, count)
  n = starting_n

  seq = []
  seq << [n, n.to_s[-1].to_i, nil]

  (1..count).map do |i|
    n = secret_number(n)
    d = n.to_s[-1].to_i
    seq << [n, d, d - seq[i - 1][1]]
  end

  seq
end


if __FILE__ == $0
  $input = File.readlines(__dir__ + '/input.txt', chomp: true).map(&:to_i)

  p part1
  p part2
end
