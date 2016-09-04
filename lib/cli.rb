require 'optparse' # for parsing command-line options
require_relative "challenge"

# The Command-Line Interface for processing the user's arguments.
class CLI
  
  # Check the department filter.
  #
  # Parameter :
  # * +department+ :: the department to filter.
  #
  # Return the +department+ if this one is valid. Otherwise, it returns an empty string (no filter).
  def self.validateDepartment(department)
    return "" if department.empty?
    Challenge::DEPARTMENTS.select{ |d| d.eql? department }.join
  end

  # Check and get the room's full name to process.
  #
  # This method always return at least one Room.
  # If empty or invalid, returns all rooms.
  #
  # Parameter: 
  # * +rooms+  :: the rooms' filter in abbreviated format. ie: "A", "B",...
  # if +rooms+ is not empty, the selected and valid rooms are returned. 
  # if +rooms+ is empty, all available rooms.
  # 
  def self.validateAndBuildRooms(rooms)
    good_rooms = rooms
                 .uniq
                 .map{ |r| "room#{r}"}
                 .select{ |r| Challenge::ROOMS.include? r }
    return Challenge::ROOMS if good_rooms.empty? 
    good_rooms
  end

  # Process CLI arguments.
  #
  # Receive the parameter +args+ and return the parsed arguments as
  # a +Hash+ or +nil+ (incorrect parameters or help).
  def self.parseCLIOptions(args)
    options = {filename: nil, department: "", rooms: Challenge::ROOMS, outputPath: nil }
    parser = OptionParser.new do|opts|
      opts.banner = "Usage: challenge [options]"
      opts.on('-f', '--filename <file>', 'input filename to process.') do |f|
        options[:filename] = f if File.exist? f
      end
      opts.on('-d', '--department <dept>', 'department selection. You can select only one in HR1, HR2, etc.') do |d|
        options[:department] = validateDepartment d
      end
      opts.on('-r', '--rooms <r1,r2,...>', Array, 'rooms to include (A to F).') do |r|
        options[:rooms] = validateAndBuildRooms r
      end
      opts.on('-o', '--output <path>', 'where to write files produced. Defaults to filename\'s folder.') do |o|
        if File.exist? o
          options[:outputPath] = o + File::Separator
        end
      end
      opts.on('-h', '--help', 'Displays Help') do
        puts opts
        return nil
      end
    end
    parser.parse! args
    if options[:filename].nil?
      STDERR.puts "Missing filename parameter"
      return nil
    end
    # check outputPath
    if options[:outputPath].nil? 
      options[:outputPath] = File.dirname(options[:filename]) + File::Separator
    end
    options
  end

end
