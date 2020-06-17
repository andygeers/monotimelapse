#!/usr/bin/env ruby

require_relative 'initialize'

require 'optparse'

def parse_options_to!(options)
  opt_parser = OptionParser.new do |opts|
    opts.banner = "Usage: #{File.basename(__FILE__)} [options] <INPUT_PATH> <OUTPUT_PATH>"

    opts.on("-t", "--total TOTAL", "Total number of frames") do |n|
      options.total_frames = n
    end

    opts.on("-s", "--stride STRIDE", "Number of frames to skip") do |s|
      options.stride = s
    end

    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end
  end
  opt_parser.parse!

  options.input_path = !ARGV[0].nil? && File.expand_path(ARGV[0])
  options.output_path = ARGV[1]

  unless options.input_path && options.output_path.present?
    puts opt_parser
    exit
  end
end

options = OpenStruct.new({
  total_frames: nil,
  stride: nil
})
parse_options_to!(options)

# Find all numbered images in the given directory
all_paths = Dir.glob(File.join(options.input_path, "*[0-9].jpg"))
sorted = all_paths.sort_by do |path|
  # Work out the file number for this one
  filename = File.basename(path)
  if match = /([0-9]+)\.jpg$/.match(path)
    match[1].to_i
  else
    MAX_INT
  end
end

if options.total_frames.present?
  stride = sorted.count / options.total_frames.to_i
elsif options.stride.present?
  stride = options.stride.to_i
else
  stride = 1
end

puts "Using stride #{stride}"


indices = Array((0 ... sorted.length).step(stride))
if sorted.present? && indices.last != sorted.count - 1
  indices << sorted.count - 1
end

# See how many digits we need
digits = indices.count.to_s.length

FileUtils::mkdir_p options.output_path

if options.input_path == File.expand_path(options.output_path)
  puts "Source and input path must be different"
  exit
end

indices.each_with_index do |path_index, new_index|
  path = sorted[path_index]

  target_path = File.join(options.output_path, "frame%0#{digits}d.jpg" % (new_index + 1))

  # Copy the file
  FileUtils.cp(path, target_path)
end
