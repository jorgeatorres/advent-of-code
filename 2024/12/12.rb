# URL: https://adventofcode.com/2024/day/12

def part1
  # Perimeter = number of sides of garden plots in the region that do not touch another garden plot in the same region.
  perimeter = Proc.new do |region|
    queue = region.dup
    common_sides = 0

    until queue.empty?
      i, j = queue.pop()

      # Find elements to the right and bottom to count inner sides.
      adjacent = region.filter {|ti, tj| (ti == i and tj == (j + 1)) or (ti == (i + 1) and tj == j) }
      common_sides += adjacent.count
    end

    4 * region.length - (2 * common_sides)
  end

  $regions.map {|r| r.length * perimeter.call(r) }.sum
end

def part2
  # Perimeter = number of sides of the region.
  perimeter = Proc.new do |region|
    # A point in the region is boundary if at least one of the adjacent points is not part of the region itself.
    # If the point that is not in the region is found by moving horizontally,
    # the boundary point describes a vertical edge. Else, a horizontal edge.
    #
    # Ex: A is added as both a vert and horizontal boundary point. B it's just vertical.
    # -
    # A|
    # B|
    # .|
    # -
    # We also save the direction since the same item in the boundary can contribute
    # different sides while moving left/right or up/down.
    # We then iterate over each possible direction and detect 'gaps' (non-consecutive coordinates) in the other direction
    # which indicate a side.
    boundary = [[-1, 0], [1, 0], [0, -1], [0, 1]].to_h{ |h| [h, []] }

    region.each do |i, j|
      boundary.keys.each do |di, dj|
        next if region.include?([i + di, j + dj])
        boundary[[di, dj]] << [i, j]
      end
    end

    sides = 0
    boundary.each do |(di, dj), points|
      points = points.group_by{ |i, j| (di == 0 ? j : i ) }

      points.each do |_, coords|
        coords = coords.map {|i, j| ( di == 0 ? i : j ) }.sort
        next if coords.empty?
        sides += 1 + (1...coords.length).sum { |n| ( coords[n] != ( coords[n - 1] + 1 ) ) ? 1 : 0 }
      end
    end

    sides
  end

  $regions.map {|r| r.length * perimeter.call(r) }.sum
end

def process_input(input)
  map = input.split.map(&:chars)
  points = (0...map.length).to_a.product((0...map.length).to_a)
  regions = []

  until points.empty? do
    # Move to a point in the grid.
    i, j = points.pop()
    plant = map[i][j]

    # Find the region containing the point.
    region = []
    queue = [[i, j]]
    until queue.empty? do
      pi, pj = queue.pop()

      # Remove point from set of all points so that we don't process it more than once.
      points.delete([pi, pj])

      next if region.include?([pi, pj])
      region << [pi, pj]

      # Adjacent points of the same type.
      adjacent = [ [pi - 1, pj], [pi + 1, pj], [pi, pj - 1], [pi, pj + 1] ]
        .filter_map { |ti, tj| [ti, tj] if ti >= 0 and tj >= 0 and ti < map.length and tj < map.length and map[ti][tj] == plant }
        .filter{ |t| ! region.include?(t) }

      queue += adjacent
    end

    regions << region
  end

  regions
end

if __FILE__ == $0
  $regions = process_input(File.read(__dir__ + '/input.txt'))

  p part1
  p part2
end
