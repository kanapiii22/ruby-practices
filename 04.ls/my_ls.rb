# 引数を取得（なければカレントディレクトリ）
target = ARGV[0] || "."

FORMAT_COL = 3

# 引数で指定されたディレクトリの内容を取得し、ソートして表示する
def collect_entries(target)
  Dir.entries(target).reject { |entry| entry.start_with?('.') }.sort
end
p collect =  collect_entries(target)

# 3列表示のために縦詰め → 横展開形式の2次元配列を作る
def format_rows(collect, column_count)
 row_count = (collect.size.to_f / column_count).ceil
 table = Array.new(row_count) { Array.new(column_count) }

 collect.each_with_index do |entry, i|
   row = i % row_count
   col = i / row_count
   table[row][col] = entry
 end

 table
end
p format = format_rows(collect,FORMAT_COL)

