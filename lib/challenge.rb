require "faker"

# Helper module for the application
module Challenge
  # All the departments.
  DEPARTMENTS = Array(1..10).map{|d| "HR#{d}"}
  # ALl the room's name.
  ROOMS = ("A".."F").to_a.map{|r| "room#{r}"}
  #FILE_WRITERS_ALL = DEPARTMENTS.product(ROOMS)
  #                    .map { |d,r| "#{d}-#{r}"}
  #                    .map { |w| {w => File.open(w, "a")} }

  # CSV Header used for generating the sample datasets
  ROW_HEADER = "department;date;roomA;roomB;roomC;roomD;roomE;roomF;code\n"
  
  # Generate a sample dataset with randomized data.
  #
  # Parameters :
  # * +filename+:: the file name to generate.
  # * +rows+:: the number of rows to create.
  def self.generate_dataset(filename, rows)
    refs = ["HALO", "GEPUR", "TEPUR", "RIRI"]
    curs = ["EUR", "GBP", "OPEC", "OPEX"]
    File.open(filename, "w") do |f|
      print "#{filename}".ljust(17)
      f << ROW_HEADER 
      (1 .. rows).each do |n|
        f << DEPARTMENTS[rand(DEPARTMENTS.size)] + ";"
        f << Faker::Date.between(Date.new(2009), Date.today).strftime("%Y-%m-%d")+";"
        ROOMS.each do |r|
          # 5% of empty rooms
          f << rand(130)+1 if rand(100) > 5
          f << ";"
        end 
        # (Empty or not) code field
        if (rand(2)>0)
          f << refs[rand(refs.size)] + "#"
          f <<  (0...3).map { (65 + rand(26)).chr }.join 
          f << "#" + curs[rand(curs.size)]
        end
        f << "\n"
        print(".") if (n % (rows * 0.1).to_i == 0)  
      end
      puts
      f.close
    end
  end
end
