VOWELS = "aeoui".chars
INVALID_STRINGS = %w(ab cd pq xy)

def vowels?(char_arr, count=3)
  char_arr.count{|c| VOWELS.include?(c)} >= count
end

def repeat?(char_arr, count=2)
  char_arr.chunk{|c| c}.map{|ch, occ| occ.size >= count}.any?
end

def invalid_string?(word)
  INVALID_STRINGS.any? {|i| word.include? i}
end

words = IO.read("./5_words.txt").split("\n")

# nice_words = words.count do |word|
#   char_arr = word.chars
#   !invalid_string?(word) && vowels?(char_arr) && repeat?(char_arr)
# end

# puts nice_words


def repeat_with_buffer?(char_arr, buffer=1)
  char_arr.map do |c|
    indexes = char_arr.each_index.select{|i| char_arr[i] == c}

    indexes.each_with_index.map do |i, index|
      rest = indexes.slice((index+1)..-1)
      rest.any?{|r| r == (i+1+buffer)}
    end.any?
  end.any?
end


def repeat?(word, count=2)
  word =~ /(.{2}).*\1/
end

nice_words = words.count do |word|
  char_arr = word.chars
  repeat?(word) && repeat_with_buffer?(char_arr)
end

puts nice_words