# 引数を取得（なければカレントディレクトリ）
target = ARGV[0] || "."

FORMAT_COL = 3

# 引数で指定されたディレクトリの内容を取得し、ソートして表示する
def collect_entries(target)
  Dir.entries(target).reject { |entry| entry.start_with?('.') }.sort
end
p collect =  collect_entries(target)

# 配列を3列に変換
def format_rows(collect, column_count)
  columns = Array.new(column_count) { [] }

  collect.each_with_index do |entry, index|
  col = index % column_count
  columns[col] << entry  # 各列に順番に詰める
  end
  columns
end
p format = format_rows(collect,FORMAT_COL)
