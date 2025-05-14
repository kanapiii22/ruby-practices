#!/usr/bin/env ruby

require 'optparse'
require 'date'

# インスタンス変数の初期設定
@month = nil
@year = nil

# コマンドラインオプションの定義
opt = OptionParser.new
opt.on('-m MONTH', Integer) { |m| @month = m }
opt.on('-y YEAR', Integer) { |y| @year = y }
# 実行時にARGVから値を取り出す
opt.parse(ARGV) 

# 年月の初期化（未指定なら今日の年月）
today = Date.today
year = @year || today.year
month = @month || today.month

# 範囲チェック（1970〜2100年）
if year < 1970 || year > 2100
  puts "対応している年は1970年から2100年までです"
  exit
end

# 月のチェック（1〜12）
if month < 1 || month > 12
  puts "月は1〜12の範囲で指定してください"
  exit
end

# 開始日と終了日
start_date = Date.new(year, month, 1)
end_date = Date.new(year, month, -1)

# ヘッダーの表示
header = "#{year}年#{month}月"
puts header.center(20)
puts "日 月 火 水 木 金 土"

# 1日の曜日（0=日, 6=土）に応じてスペースを出力
#wdayはインスタンスメソッド
# 0=日, 1=月, 2=火, 3=水, 4=木, 5=金, 6=土
start_date.wday.times do
  print "   "
end

# 日付を1日ずつ表示（右揃え2桁 + 半角スペース）
date = start_date
while date <= end_date
  print date.day.to_s.rjust(2) + " "
  print "\n" if date.wday == 6
  date += 1
end
# 最後に改行
puts "" 

