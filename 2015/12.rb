require 'json'
raw = IO.read("./12_json.txt")
json = JSON.parse(raw)

@sum = 0

def iterate(obj)
    case
    when obj.is_a?(Hash)
      return if obj.values.include?('red')
      obj.values.each{|v| iterate(v)}
    when obj.is_a?(Array)
      obj.each{|v| iterate(v)}
    when obj.is_a?(Integer)
      @sum += obj
    end
end

iterate(json)
p @sum