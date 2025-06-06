#!/usr/bin/env ruby
# frozen_string_literal: true

FRAME_COUNT = 10
def parse_input(input)
  input.split(',').map { |s| s == 'X' ? 10 : s.to_i }
end

def make_frames(shots)
  frames = []
  i = 0

  (FRAME_COUNT - 1).times do
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

def calculate_score(frames)
  total = 0
  frames.each_with_index do |frame, idx|
    total += frame.sum
    if idx < FRAME_COUNT - 1
      total += strike_bonus(frames, idx) if strike?(frame)
      total += spare_bonus(frames, idx) if spare?(frame) && !strike?(frame)
    end
  end
  total
end

def strike_bonus(frames, idx)
  next_frame = frames[idx + 1]

  if strike?(next_frame) && frames[idx + 2]
    10 + frames[idx + 2][0]
  else
    next_frame[0] + (next_frame[1] || 0)
  end
end

def spare_bonus(frames, idx)
  frames[idx + 1][0]
end

def strike?(frame)
  frame[0] == 10
end

def spare?(frame)
  frame.size == 2 && frame.sum == 10
end

shots = parse_input(ARGV[0])
frames = make_frames(shots)
puts calculate_score(frames)