# URL: https://adventofcode.com/2024/day/24

def part1
  wires, ops = parse_input()

  n = 0
  until ops.empty?
    n = n % ops.length
    w1, gate, w2, w3 = ops[n]

    if wires.key?(w1) and wires.key?(w2)
      case gate
      when 'AND' then res = (wires[w1] & wires[w2])
      when 'OR' then res = (wires[w1] | wires[w2])
      when 'XOR' then res = (wires[w1] ^ wires[w2])
      else raise 'Invalid gate!'
      end

      wires[w3] = res
      ops.delete_at(n)
      n -= 1
    end

    n += 1
  end

  wires
    .filter{ |k, _| k[0] == 'z' }
    .sort
    .map(&:last)
    .reverse
    .join
    .to_i(2)
end

def part2
  wires, ops = parse_input()

  # Highest output z wire: z{N}.
  zn = ops.filter_map{ |*a, wr| wr if wr[0] == 'z' }.sort.last

  incorrect = []

  # Ok. So I did some reading on how binary numbers are summed.
  # https://byjus.com/maths/binary-addition/
  # https://stackoverflow.com/questions/7334832/are-addition-and-bitwise-or-the-same-in-this-case
  # 0 + 0 = 0
  # 0 + 1 = 1
  # 1 + 0 = 1
  # 1 + 1 = 10 (that is, 0 and you carry 1).
  # So pretty much a + b = a xor b except when there's carry (i.e. a ^ b == 0)

  # So...
  # - All operations zK <- w1 OP w2 have to be OP=XOR, except possibly for the zN one. Otherwise, that zK isn't the
  #   result of a binary addition.
  # - If the operation is r <- a XOR b, then there can't be an operation (r OR b) or (a OR r).
  ops.each do |w1, op, w2, wr|
    if wr[0] == 'z' and op != 'XOR' and wr != zn
      incorrect << wr
    end

    if op == 'XOR' and wr[0] != 'z' and ! ['x', 'y'].include?(w1[0]) and ! ['x', 'y'].include?(w2[0])
      incorrect << wr
    end

    if op == 'XOR' and ops.any? { |a, o, b, r| (wr == a || wr == b) && o == 'OR' }
      incorrect << wr
    end

    if op == 'AND' and (w1 != 'x00' and w2 !='x00') and ops.any? { |a, o, b, r| (wr == a || wr == b) && o != 'OR' }
      incorrect << wr
    end

  end

  incorrect.uniq.sort.join(',')
end

def parse_input()
  f = File.read(__dir__ + '/input.txt', chomp: true)
  wires_initial = f.scan(/(?<var>.{3}): (?<bit>[0-1]{1})\n?/).map { |x, y| [x, y.to_i] }.to_h
  ops = f.scan(/(?<wire1>.{3}) (?<gate>.{2,3}) (?<wire2>.{3}) -> (?<wire3>.{3})\n?/)

  [wires_initial, ops]
end

if __FILE__ == $0
  p part1
  p part2
end
