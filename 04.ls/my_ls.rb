#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLUMN_COUNT = 3
show_all = false
reverse_order = false

opt = OptionParser.new
opt.on('-a') { show_all = true }
opt.on('-r') { reverse_order = true }
opt.parse!(ARGV)

def collect_entries(target, show_all)
  entries = Dir.entries(target)
  entries.reject! { |entry| entry.start_with?('.') } unless show_all
  entries.sort
end

def entries_reverse(entries)
  entries.reverse
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
entries = collect_entries(target, show_all)
entries = entries_reverse(entries) if reverse_order
entry_table = build_vertical_table(entries, COLUMN_COUNT)
print_rows(entry_table)
