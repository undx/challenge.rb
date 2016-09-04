require 'csv'

require_relative 'challenge'

# Raised when we have an invalid structure CSV
class WorkerException < StandardError
end

# Parse and process the input CSV file and generate the outputs.
class Worker
  # Represent a row of the input file according the specifications. 
  InputRow = Struct.new(:department, :date, :roomA, :roomB, :roomC, :roomD, :roomE, :roomF, :code)

  # Read and check filename and write the relevant output files.
  #
  # Receive the following parameters :
  # * +filename+  : the input file to process.
  # * +department+ : the department to filter. Otherwise, all departements.
  # * +rooms+ : the room selection to output.
  # * +path+ : the path where to write generated files.
  #
  # Throws a WorkerException on invalid structure in the CSV file.
  def self.process(filename, department, rooms, path)
    writers = {}
    start = Time.now  
    CSV.foreach(filename, { headers: true, col_sep: ';' }).each do |row|
      # create an InputRow struct to hold values.
      input = InputRow.new(row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8])
      # check if the file is valid.
      raise WorkerException, "Invalid CSV strucure in input file !" if input.department.nil? || input.date.nil?
      # filter on department (or not).
      if (department.empty? || input.department==department)
        code = input.code.nil? ? ["", ""] : input.code.split(/#.*#/) 
        rooms.each do |room| # iterate thru rooms
          room_value =  input.to_h[room.to_sym] # get value using to_h(ash) with room's name as key to_sym(bol) 
          unless room_value.nil?
            key = "#{input.department}-#{room.sub(/^r/, 'R')}"
            file = "#{path}#{key}.csv"
            writer = writers[key]
            if writer.nil?
              writer = File.new(file, 'a')
              writers[key] = writer
            end
            # dumps to department room file.
            writer << input.department + ";" + input.date + ";"  + room_value + ";"+  code[0]  + ";"+  code[1] + $/
          end
        end 
      end
    end
    writers.each { |wk, wv| wv.close }
    puts "File processed in #{((Time.now - start) * 1000).to_i} ms."
  end
end
