# URL: https://adventofcode.com/2024/day/7

def part1
  find_total_calibration($input, [:+, :*])
end

def part2
  find_total_calibration($input, [:+, :*, :number_concat])
end

def number_concat(x,y)
  (x.to_s + y.to_s).to_i
end

def find_total_calibration(input, valid_operators)
  sum = 0

  input.each do |expected, *args|
    combos = valid_operators.product( *(0...(args.length - 2)).map {|n| valid_operators } )

    combos.each do |ops|
      result = args.inject do |r,x|
        op = ops.shift
        if r.respond_to?(op)
          r.send(op, x)
        else
          method(op).call(r, x)
        end
      end

      if result == expected
        sum += result
        break
      end

    end
  end

  sum
end

if __FILE__ == $0
  $input = File.read( __dir__ + '/input.txt')
    .gsub( ':', ' ' )
    .split("\n")
    .map{|x| x.split(' ').map(&:strip).map(&:to_i) }

  p part1
  p part2
end
