password = 'vzbxxyzz'.next

def straight?(p)
  p.chars.each_cons(3).to_a.map do |s|
    # puts [s[0], s[1], s[2]].inspect
    s[0].next == s[1] && s[1].next == s[2]
  end.any?
end

def two_pair?(p)
  p.chars.chunk{|c| c}.to_a.map{|g| g[1].size}.map{|c| c >= 2}.reject{|b| !b}.count >= 2

end

loop do
  if straight?(password) && !password[/[iol]/] && two_pair?(password)
    break
  else
    password = password.next
  end
end

puts password