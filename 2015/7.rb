# 123 -> x
# 456 -> y
# x AND y -> d
# x OR y -> e
# x LSHIFT 2 -> f
# y RSHIFT 2 -> g
# NOT x -> h
# NOT y -> i

require './problem7/scanner'
require './problem7/parser'

instructions = IO.read("./7_instructions.txt").split("\n")

@result = []
instructions.each do |instr|
  tokens = Problem7::Scanner.scan(instr)
  code   = Problem7::Parser.new.parse(tokens)
  @result << code
end

@result.sort_by!{|code| code.split(" = ")[0]}
singles = @result.select{|code| code.split(" = ")[0].length == 2 }
@result = @result - singles
_a = singles.shift
@result = singles + @result + [_a, "puts _a"]


File.open("7_compiled.rb", "w"){|f| f.write(@result.join("\n"))}