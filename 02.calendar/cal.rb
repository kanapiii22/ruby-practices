#!/usr/bin/env ruby

require 'optparse'
require 'date'

@month = nil
@year = nil

opt = OptionParser.new
opt.on('-m MONTH', Integer) { |m| @month = m }
opt.on('-y YEAR', Integer) { |y| @year = y }
opt.parse(ARGV)

today = Date.today
year = @year || today.year
month = @month || today.month

if year < 1970 || year > 2100
  puts '対応している年は1970年から2100年までです'
  exit
end

if month < 1 || month > 12
  puts '月は1〜12の範囲で指定してください'
  exit
end

# 開始日と終了日
start_date = Date.new(year, month, 1)
end_date = Date.new(year, month, -1)

header = "#{year}年#{month}月"
puts header.center(20)
puts '日 月 火 水 木 金 土'

# 1日の曜日（0=日, 6=土）に応じてスペースを出力
print '   ' * start_date.wday

# 日付を1日ずつ表示（右揃え2桁 + 半角スペース）
(start_date..end_date).each do |date|
  print date.day.to_s.rjust(2) + ' '
  puts if date.saturday?
end

puts
