require 'benchmark'
require 'fileutils'
require './lib/challenge'
require './lib/worker'

TESTS = 1
tiny = "./data/tiny.csv"
small = "./data/small.csv"
medium = "./data/medium.csv"
large = "./data/large.csv"
huge = "./data/huge.csv"
department = ""
rooms = Challenge::ROOMS
path = "./tmp/"
# Test the application with sample datasets.
# We clear the output folder before each call.
Benchmark.bmbm do |x| 
  FileUtils.rm_rf(path); FileUtils.mkdir(path)
  x.report("tiny")   { Worker.process(tiny, department, rooms, path)}
  FileUtils.rm_rf(path); FileUtils.mkdir(path)
  x.report("small")  { Worker.process(small, department, rooms, path)}
  FileUtils.rm_rf(path); FileUtils.mkdir(path)
  x.report("medium") { Worker.process(medium, department, rooms, path)}
  FileUtils.rm_rf(path); FileUtils.mkdir(path)
  x.report("large")  { Worker.process(large, department, rooms, path)}
  FileUtils.rm_rf(path); FileUtils.mkdir(path)
  x.report("huge")   { Worker.process(huge, department, rooms, path)}
  FileUtils.rm_rf(path); FileUtils.mkdir(path)
end
