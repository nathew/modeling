# MIT License
#
# Copyright (c) 2018 nathew
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'csv'

def get_time_str
  t = DateTime.now
  time_str = "%d-%02d-%02d-%02d%02d%02d" %
             [t.year, t.mon, t.mday, t.hour, t.min, t.sec]
end

if ARGV.size() > 0 then
  input_filename = ARGV[0]
  input_file = File::open(input_filename)
  # need error check
  output_filename = input_filename.gsub(/\.txt$/, "_")
  output_filename = output_filename + get_time_str() + ".csv"
else
  input_filename = "smvres_" + get_time_str() + ".txt"
  input_file = STDIN
  output_filename = input_filename.gsub(/\.txt$/, ".csv")
end

lines = input_file.readlines

header = []
rows = []
row  = []
index = {}

lines.each do |line|
  if line.match(/-> State:\s*[\d.]+\s*<-/) then
    if !row.empty? then
      rows << row
    end
    row = Array.new(header.size())
  else
    line.chomp!
    line.gsub!(/\s*/, "")
    line.match(/^(\w+)=([\d\w]+)$/) do |md|
      name  = md[1]
      value = md[2]
      if !header.include?(name) then
        index[name] = header.size()
        header << name
      end
      row[index[name]] = value
    end
  end
end

CSV.open(output_filename, "w") do |csv|
  csv << header
  rows.each do |row|
    csv << row
  end
end
