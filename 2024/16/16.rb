# URL: https://adventofcode.com/2024/day/16

def part1
  best, _ = dijkstra2($maze)
  best
end

def part2
  _, visited = dijkstra2($maze)
  visited.uniq.length
end

# Dijkstra (without a priority queue) was good for the examples, but failed with
# my input. A* did much better (though still took a bit of time) and was a bit complex
# for the second part.
def dijkstra2(maze)
  start = maze[:start]
  goal = maze[:goal]
  grid = maze[:maze]

  # Dijkstra.
  seen = []
  dist = Hash.new(1e9)
  best = 1e9
  path_through = Hash.new([])
  q = PriorityQueue.new

  # Queue:
  # <priority, t, pos, dir, path>
  # t is used to disambiguate equal priorities.
  t = 0
  q << [0, t, start, 1i, [start]]
  # path_through[[start, 1i]] = [start]

  until q.empty?
    cost, _, *state, path = q.pop()
    pos, dir = state

    next if cost > dist[state]

    dist[state] = cost

    if pos == goal and cost <= best
      seen += path
      best = cost
    end

    [[1, 1], [+1i, 1000 + 1], [-1i, 1000 + 1]].each do |rot, move_cost|
      c = move_cost + cost
      t = t + 1
      new_pos = pos + dir * rot
      new_dir = dir * rot
      new_state = [new_pos, new_dir]

      next if ! grid.include?(new_pos)

      q << [c, t, new_pos, new_dir, path + [new_pos]]
    end
  end

  [best, seen]
end

class PriorityQueue
  attr_accessor :heap

  def initialize(h=nil)
    if h.nil?
      @heap = []
    else
      @heap = h.dup
    end
  end

  def <<(item)
    @heap << item
    sift_up(@heap.length - 1)
  end

  def pop()
    return nil if @heap.empty?

    @heap[0], @heap[-1] = @heap[-1], @heap[0]
    e = @heap.pop
    sift_down(0) unless @heap.empty?
    e
  end

  def empty?
    @heap.empty?
  end

  private

  def sift_up(index)
    return if index < 1

    parent_index = (index - 1) / 2
    cmp = @heap[parent_index] <=> @heap[index]
    if (cmp > 0)
      @heap[index], @heap[parent_index] = @heap[parent_index], @heap[index]
      sift_up(parent_index)
    end
  end

  def sift_down(index)
    left_i = index * 2 + 1
    right_i = index * 2 + 2
    i = index

    i = left_i if left_i < @heap.length && (@heap[left_i] <=> @heap[i]) < 0
    i = right_i if right_i < @heap.length && (@heap[right_i] <=> @heap[i]) < 0

    return if index == i

    @heap[index], @heap[i] = @heap[i], @heap[index]
    sift_down(i)
  end
end

def parse_input
  maze = {
    :maze  => Hash.new('#'),
    :start => nil,
    :goal  => nil
  }

  $input.split.each.with_index do |row, i|
    row.chars.each.with_index do |c, j|
      pos = i + j*1i

      if c == 'S'
        maze[:start] = pos
      elsif c == 'E'
        maze[:goal] = pos
      end

      maze[:maze][i + j*1i] = c if c != '#'
    end
  end

  maze
end

if __FILE__ == $0
  $input = File.read(__dir__ + '/input.txt')
  $maze = parse_input()

  p part1
  p part2
end
