# 引数を取得（なければカレントディレクトリ）
target = ARGV[0] || "."

# 引数で指定されたディレクトリの内容を取得し、ソートして表示する
def collect_entries(target)
  Dir.entries(target).reject { |entry| entry.start_with?('.') }.sort
end
puts collect_entries(target)