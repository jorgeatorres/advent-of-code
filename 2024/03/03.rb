# URL: https://adventofcode.com/2024/day/3

def part1
  $input.scan(/mul\(([0-9]+),([0-9]+)\)/).sum{|x| x[0].to_i * x[1].to_i }
end

def part2
  enabled = true
  sum = 0

  $input.scan(/(don't\(\))|(do\(\))|(mul\(([0-9]+),([0-9]+)\))/) do |m|
    args = m.compact

    enabled = false if args[0] == "don't()"
    enabled = true if args[0] == "do()"
    next if not enabled

    sum += (args[1].to_i * args[2].to_i)
  end

  sum
end

if __FILE__ == $0
  $input = File.read( __dir__ + '/input.txt').strip

  p part1
  p part2
end
