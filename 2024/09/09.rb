# URL: https://adventofcode.com/2024/day/9

def part1
  disk = parse_input($input)

  loop do
    range1, index = disk.each_with_index.find { |e, i| e.free? }
    break if range1.nil?

    range2 = disk.pop
    next if range2.free?

    # Move as much of 'last' to 'free' as possible.
    to_move = [range1.length, range2.length].min

    disk[index] = DiskRange.new(range2.id, range1.start, range1.start + to_move - 1)

    diff = range1.length - disk[index].length
    if diff > 0
      disk.insert(index + 1, DiskRange.new(range1.id, range1.start + to_move, range1.end))
    end

    diff = range2.length - to_move
    if diff > 0
      new_element = DiskRange.new(range2.id, range2.start, range2.start + diff - 1)
      disk << new_element
    end
  end

  disk_checksum(disk)
end

def part2
  disk = parse_input($input)

  index = disk.length - 1
  loop do
    break if index == 0

    element = disk[index]

    if element.free?
      index -= 1
      next
    end

    # Find first free space that would fit entire element.
    free, free_index = disk.each_with_index.find { |e, i| e.free? and e.length >= element.length and i < index }
    if free.nil?
      index -= 1
      next
    end

    disk[free_index] = DiskRange.new(element.id, free.start, free.start + element.length - 1)
    disk[index] = DiskRange.new(free.id, element.start, element.end)

    diff = free.length - element.length
    if diff > 0
      disk.insert(free_index + 1, DiskRange.new(free.id, disk[free_index].end + 1, disk[free_index].end + diff))
      index += 1
    end

    index -= 1
  end

  disk_checksum(disk)
end

class DiskRange
  attr_reader :id, :start, :end

  def initialize(id, start, end_)
    @id = id
    @start = start
    @end = end_
  end

  def length
    @end - @start + 1
  end

  def free?
    @id.nil? and length > 0
  end
end

def disk_checksum(disk)
  # Checksum is (id1 * pos1) + (id2 * pos2) + ...
  disk.inject(0) do |memo, range|
    memo + (range.id.nil? ? 0 : ((range.start..range.end).map{ |i| i * range.id }.sum))
  end
end

def parse_input(input)
  n = 0
  input.chars.map(&:to_i).each_with_index.map do |no_blocks, i|
    res = 0 == no_blocks ? nil : DiskRange.new( i % 2 == 0 ? ( i / 2 ) : nil, n,  n + no_blocks - 1)
    n += no_blocks
    res
  end.compact
end

if __FILE__ == $0
  $input = File.read( __dir__ + '/input.txt').strip

  p part1
  p part2
end
