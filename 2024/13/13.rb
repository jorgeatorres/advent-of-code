# URL: https://adventofcode.com/2024/day/13

def part1
  cost_a = 3
  cost_b = 1

  $input.sum do |machine|
    # Find solution to machine problem.
    # This is a 2x2 system of equations:
    #  x = Δx_a p_a + Δx_b p_b
    #  y = Δy_a p_a + Δy_b p_b
    # where x, y correspond to the prize location, p_a, p_b are the number of presses of A and B and
    # Δx_a, Δy_a, Δx_b, Δy_b are the change in x and y that pressing buttons A and B produces.
    #
    # Solving the system while avoiding division (to reduce precision loss) leads to
    # (Δx_a y - Δy_a x) = p_b(Δx_a Δy_b - Δy_a Δx_b).
    # Before attempting to solve for Pb we check that the division would lead to an integer solution.
    # Otherwise, the prize can't be obtained.

    s1 = (machine[:button_a][0] * machine[:prize][1]) - (machine[:button_a][1] * machine[:prize][0])
    s2 = (machine[:button_a][0] * machine[:button_b][1]) - (machine[:button_a][1] * machine[:button_b][0])

    next 0 if s1 % s2 != 0

    p_b = s1 / s2

    # Δx_a p_a = x - Δx_b p_b
    d = machine[:prize][0] - (p_b * machine[:button_b][0])
    next 0 if d % machine[:button_a][0] != 0

    p_a = d / machine[:button_a][0]
    p_a * cost_a + p_b * cost_b
  end
end

def part2
  # Modifiy $input to make X,Y locations 10000000000000 more.
  $input.map! do |m|
    m[:prize].map! { |x| x + 10000000000000 }
    m
  end

  part1
end

def parse_input(input)
  re_buttons = /X\+?(?<dx>\d+), Y\+(?<dy>\d+)/
  re_prize = /X=(?<x>\d+), Y=(?<y>\d+)/

  machines = input.split("\n\n").map do |txt|
    lines = txt.split("\n")

    button_a = re_buttons.match(lines[0])
    button_b = re_buttons.match(lines[1])
    prize = re_prize.match(lines[2])
    {
      :button_a => [button_a['dx'].to_i, button_a['dy'].to_i],
      :button_b => [button_b['dx'].to_i, button_b['dy'].to_i],
      :prize    => [prize['x'].to_i, prize['y'].to_i]
    }
  end
end

if __FILE__ == $0
  $input = parse_input(File.read(__dir__ + '/input.txt'))

  p part1
  p part2
end
