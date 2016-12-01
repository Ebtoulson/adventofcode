require 'digest'

SECRET = 'yzbqklnj'

answer = 0

loop do
  hex = Digest::MD5.hexdigest("#{SECRET}#{answer}")
  break if hex.start_with?('000000')
  answer += 1
end

puts answer