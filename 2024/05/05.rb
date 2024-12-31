# URL: https://adventofcode.com/2024/day/5

def part1
  rules, updates = process_input

  updates
    .filter_map {|u| u[(u.size / 2)] if is_in_correct_order(u, rules) }
    .sum
end

def part2
  rules, updates = process_input

  updates
    .filter {|u| ! is_in_correct_order(u, rules) }
    .map {|u| u.sort { |a,b| ( rules.has_key?(b) and rules[b].include?(a) ) ? 1 : ( ( rules.has_key?(a) and rules[a].include?(b) ) ? -1 : 0 ) } }
    .map {|u| u[u.size / 2] }
    .sum
end

def process_input
  rules = {}
  updates = []

  $input.each do |l|
    if l.include?(',')
      updates << l.split(',').map(&:to_i)
      next
    end

    before, after = l.split('|').map(&:to_i)
    rules[before] = rules.fetch(before, []).push(after)
  end

  [rules, updates]
end

def is_in_correct_order(update, rules)
  update.reverse.each_with_index do |e, i|
    next if not rules.has_key?(e)
    must_be_after = rules[e]
    rest = update.slice(0, update.size - i - 1)
    return false if rest.intersect?(must_be_after)
  end

  true
end

if __FILE__ == $0
  $input = File.readlines( __dir__ + '/input.txt').map(&:strip)

  p part1
  p part2
end
