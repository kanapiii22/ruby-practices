#!/usr/bin/env ruby
# frozen_string_literal: true

def parse_input(input)
  input.split(',').map { |s| s == 'X' ? 10 : s.to_i }
end

def make_frames(shots)
  frames = []
  i = 0

  9.times do
    if shots[i] == 10
      frames << [10]
      i += 1
    else
      frames << [shots[i], shots[i + 1]]
      i += 2
    end
  end

  frames << shots[i..]
end

# スコア計算
def calculate_score(frames)
  total = 0

  frames.each_with_index do |frame, idx|
    if idx < 9
      if frame[0] == 10 # ストライク
        total += 10 + strike_bonus(frames, idx)
      elsif frame.sum == 10 # スペア
        total += 10 + spare_bonus(frames, idx)
      else
        total += frame.sum
      end
    else
      total += frame.sum
    end
  end

  puts total
end

def strike_bonus(frames, idx)
  next_frame = frames[idx + 1]

  if next_frame[0] == 10 && frames[idx + 2]
    10 + frames[idx + 2][0]
  else
    next_frame[0] + (next_frame[1] || 0)
  end
end

def spare_bonus(frames, idx)
  frames[idx + 1][0]
end

shots = parse_input(ARGV[0])
frames = make_frames(shots)
score = calculate_score(frames)

