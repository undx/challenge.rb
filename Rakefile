require 'rdoc/task'
require "./lib/challenge"

Rake::RDocTask.new do |rd|
  rd.rdoc_dir = "doc"
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
end

desc "Generate sample datasets"
task :generate_datasets do |t|
  puts "Generating the sample datasets in data folder."
  FileUtils.mkdir_p "./data/"
  { "tiny.csv": 100,
    "small.csv": 1_000,
    "medium.csv": 100_000,
    "large.csv": 1_000_000,
    "huge.csv":10_000_000 }.each do |dk, dv|
    Challenge::generate_dataset("./data/#{dk}", dv)
  end
  puts "Done."
end
