# URL: https://adventofcode.com/2024/day/15

def part1
  grid, bounds, moves = parse_input($input)

  moves.each {|c| move_on_grid(grid, bounds, c) }

  # GPS coordinate of a box is equal to 100 times its distance from the top edge of the map plus its distance from the left edge of the map.
  # The lanternfish would like to know the sum of all boxes' GPS coordinates after the robot finishes moving.
  grid
    .filter_map {|k, v| k if v == 'O' }
    .map {|p| 100 * p.imag + p.real }
    .sum
end

def part2
  initial_grid, initial_bounds, moves = parse_input($input)

  # Re-scale grid.
  grid = Hash.new('.')
  (0..initial_bounds[0]).each do |x|
    (0..initial_bounds[1]).each do |y|
      pos = x + 1i*y
      new_pos = (2 * pos.real) + 1i*pos.imag

      case initial_grid[pos]
      when '#' then grid[new_pos], grid[new_pos + 1] = ['#', '#']
      when 'O' then grid[new_pos], grid[new_pos + 1] = ['[', ']']
      when '.' then grid[new_pos], grid[new_pos + 1] = ['.', '.']
      when '@' then grid[new_pos], grid[new_pos + 1] = ['@', '.']
      end
    end
  end

  bounds = [2 * initial_bounds[0], initial_bounds[1] ]

  # Move!
  moves.each { |c| move_on_grid(grid, bounds, c) }

  grid
    .filter_map { |k,v| k if v == '[' }
    .map { |t| 100 * t.imag + t.real }
    .sum
end

def move_on_grid(grid, bounds, move)
  width, height = bounds

  dir = {'<' => -1, '>' => 1, 'v' => 1i, '^' => -1i}[move]
  is_box = ['[', ']', 'O']
  pos = grid.key('@')
  next_pos = pos + dir

  return if grid[next_pos] == '#'

  if is_box.include?(grid[next_pos])
    # Figure out which boxes to move.
    boxes_to_move = []

    q = [next_pos] # queue
    until q.empty? do
      e = q.pop

      if grid[e] == '#'
        boxes_to_move.clear
        break
      end

      next if grid[e] == '.'
      next if boxes_to_move.include?(e)

      boxes_to_move << e

      # Adjacent in the direction of movement.
      q << e + dir
      q << e - 1 if grid[e] == ']'
      q << e + 1  if grid[e] == '['
    end

    orig_values = grid.values_at(*boxes_to_move)
    boxes_to_move.each { |p| grid[p] = '.' }
    boxes_to_move.each{ |p| grid[p + dir] = orig_values.shift }
  end

  # Move to the empty location.
  if grid[next_pos] == '.'
    grid[pos], grid[next_pos] = '.', '@'
  end
end

def parse_input(input)
  moves = []
  grid = Hash.new('.')
  bounds = [0, 0]

  input.split("\n").each_with_index do |l, y|
    if l.start_with?('#')
      bounds[1] = [y + 1, bounds[1]].max

      l.chars.each_with_index do |t, x|
        bounds[0] = [x + 1, bounds[0]].max
        next if t == '.'
        grid[x + 1i*y] = t
      end
    else
      moves += l.chars
    end
  end

  [grid, bounds, moves]
end

if __FILE__ == $0
  $input = File.read(__dir__ + '/input.txt')

  p part1
  p part2
end
