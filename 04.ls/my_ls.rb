#!/usr/bin/env ruby
# frozen_string_literal: true

COLUMN_COUNT = 3

def collect_entries(target)
  Dir.entries(target).reject { |entry| entry.start_with?('.') }.sort
end

# 3列表示のために縦詰め → 横展開形式の2次元配列を作る
def build_vertical_table(entries, column_count)
  row_count = (entries.size.to_f / column_count).ceil
  table = Array.new(row_count) { Array.new(column_count) }

  entries.each_with_index do |entry, i|
    row = i % row_count
    col = i / row_count
    table[row][col] = entry
  end

  table
end

def print_rows(rows)
  max_width = rows.flatten.compact.map(&:length).max
  rows.each do |row|
    puts row.map { |e| (e || '').ljust(max_width + 2) }.join
  end
end

target = ARGV[0] || '.'
entries = collect_entries(target)
format = build_vertical_table(collect, COLUMN_COUNT)
print_rows(format)
