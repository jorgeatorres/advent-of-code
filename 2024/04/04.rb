# URL: https://adventofcode.com/2024/day/4

def part1
  occurrences = 0

  (0..($input.size * $input.size)).each do |n|
    row, col = n / $input.size, n % $input.size

    [ [1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1] ].each do |dx, dy|
      str = (0..3)
        .map {|d| [row + (dy * d), col + (dx * d) ] }
        .reject {|j, i| i < 0 or i >= $input.size or j < 0 or j >= $input.size }
        .map {|j, i| $input[j][i] }
        .join

      occurrences += 1 if str == "XMAS"
    end
  end

  occurrences
end

def part2
  occurrences = 0

  (0...($input.size * $input.size)).each do |n|
    row, col = n / $input.size, n % $input.size
    next if $input[row][col] != 'A'

    diag1 = [ [row - 1, col - 1], [row, col], [row + 1, col + 1] ]
      .reject {|i, j| i < 0 or j < 0 or i >= $input.size or j >= $input.size }
      .map {|i, j| $input[i][j] }
      .join

    diag2 = [ [row - 1, col + 1], [row, col], [row + 1, col - 1] ]
      .reject {|i, j| i < 0 or j < 0 or i >= $input.size or j >= $input.size }
      .map {|i, j| $input[i][j] }
      .join

    occurrences +=1 if (diag1 == "MAS" or diag1 == "SAM") and (diag2 == "MAS" or diag2 == "SAM")
  end

  occurrences
end

if __FILE__ == $0
  $input = File.readlines( __dir__ + '/input.txt').map {|x| x.strip.chars }

  p part1
  p part2
end
