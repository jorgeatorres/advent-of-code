# URL: https://adventofcode.com/2024/day/6

def part1
  guard_path = [$grid.guard]

  loop do
    guard_path << $grid.move_guard
    break if ! $grid.can_guard_move()
  end

  guard_path.uniq.count
end

def part2
  $grid.reset!

  # Without new obstacles, the guard visits certain locations. Putting an obstacle outside of any of those locations
  # wouldn't make a difference, so we only need to try locations that get visited during a no-obstacle walk.
  possible_obstacles = []
  loop do
    possible_obstacles << $grid.move_guard
    break if ! $grid.can_guard_move
  end

  loops = 0

  $grid.reset!
  possible_obstacles.delete($grid.guard)
  possible_obstacles.uniq!

  possible_obstacles.each_with_index do |p, i|
    $grid[p.x, p.y] = '#'
    loops += 1 if $grid.guard_loops?
    $grid.reset!
  end

  loops
end

Point = Struct.new(:x, :y)

class Grid
  DIRECTIONS = ['^', '>', 'v', '<']
  DELTAS = [Point.new(0, -1), Point.new(1, 0), Point.new(0, 1), Point.new(-1, 0)]

  attr_reader :bounds, :guard

  def initialize(input)
    @grid = input.is_a?(Array) ? input : input.split.map(&:chars)
    @bounds = Point.new(@grid[0].length, @grid.length)

    @guard = Point.new()
    @guard.y = @grid.index{ |x| x.include?('^') }
    @guard.x = @grid[@guard.y].index('^')

    @guard_initial = @guard.clone
    @grid_initial = @grid.map(&:clone).clone
  end

  def [](x, y)
    @grid[y][x]
  end

  def []=(x, y, val)
    @grid[y][x] = val
  end

  def move_guard
    return unless can_guard_move()

    dir = @grid[@guard.y][@guard.x]
    dir_index = DIRECTIONS.index(dir)

    new_pos = Point.new(@guard.x + DELTAS[dir_index].x, @guard.y + DELTAS[dir_index].y)
    if @grid[new_pos.y][new_pos.x] == '#'
      dir = DIRECTIONS.at((dir_index + 1) % DIRECTIONS.length)
      new_pos = @guard
    else
      @grid[@guard.y][@guard.x] = '.'
      @guard = new_pos
    end

    @grid[@guard.y][@guard.x] = dir
    new_pos
  end

  def can_guard_move
    @guard.x >= 0 and @guard.y >= 0 and @guard.x < (@bounds.x - 1) and @guard.y < (@bounds.y - 1)
  end

  def guard_loops?
    visited = Hash.new(false)
    visited[['^', @guard]] = true

    loop do
      move_guard
      visiting = [@grid[@guard.y][@guard.x], @guard]

      if visited.key?(visiting)
        return true
      end

      visited[visiting] = true

      break if ! can_guard_move()
    end

    false
  end

  def reset!
    @grid = @grid_initial.map(&:clone).clone
    @guard = @guard_initial.clone
  end
end

if __FILE__ == $0
  $grid = Grid.new(File.read( __dir__ + '/input.txt').strip)

  p part1
  p part2
end

