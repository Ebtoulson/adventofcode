module Problem7
  module Scanner
    def self.scan(source)
      tokens = []

      puts source.inspect
      while !source.empty?
        case source
        when /\A[\s+]/
          source.slice!(0, $&.size)
        when /\A[0-9]+/
          tokens << [:NUM, $&.to_i]
          source.slice!(0, $&.size)
        when /\A[a-z]+/
          tokens << [:VAR, $&]
          source.slice!(0, $&.size)
        when /\A[A-Z]+/
          tokens << [:OP, $&]
          source.slice!(0, $&.size)
        when /\A(->){1}/
          tokens << [$&, $&]
          source.slice!(0, $&.size)
        else
          STDERR.puts "unknown input at '#{source[0..10]}'"
          exit 1
        end
      end
      
      tokens
    end
  end
end