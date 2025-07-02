#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN_COUNT = 3
show_all = false
reverse_order = false
long_format = false

opt = OptionParser.new
opt.on('-a') { show_all = true }
opt.on('-r') { reverse_order = true }
opt.on('-l') { long_format = true }
opt.parse!(ARGV)

def collect_entries(target, show_all)
  entries = Dir.entries(target)
  entries.reject! { |entry| entry.start_with?('.') } unless show_all
  entries.sort
end

def format_mode(mode)
  type = case mode & 0o170000
         when 0o040000 then 'd'
         when 0o120000 then 'l'
         when 0o100000 then '-'
         else '?'
         end

  # パーミッション（各3ビットごと）
  perms = (0..2).map do |i|
    shift = 6 - i * 3
    bits = (mode >> shift) & 0b111
    [
      bits & 0b100 != 0 ? 'r' : '-',
      bits & 0b010 != 0 ? 'w' : '-',
      bits & 0b001 != 0 ? 'x' : '-'
    ].join
  end.join

  type + perms
end

def display_file_info(path)
  stat = File.lstat(path)
  mode = format_mode(stat.mode)
  nlink    = stat.nlink
  owner    = Etc.getpwuid(stat.uid).name
  group    = Etc.getgrgid(stat.gid).name
  size     = stat.size
  mtime    = stat.mtime.strftime('%-m %e %H:%M')
  filename = File.basename(path)

  puts "#{mode} #{nlink} #{owner} #{group} #{size.to_s.rjust(4)} #{mtime} #{filename}"
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
entries = entries.reverse if reverse_order

if long_format
  entries.each do |entry|
    path = File.join(target, entry)
    display_file_info(path)
  end
else
  table = build_vertical_table(entries, COLUMN_COUNT)
  print_rows(table)
end
