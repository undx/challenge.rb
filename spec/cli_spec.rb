require "cli"

describe CLI do

  describe "parseCLIOptions" do
    context "given the arguments on command-line" do
      it("return nil and print usage on --help.") do
        expect(CLI.parseCLIOptions(["--help"])).to eql (nil)
      end
      it("return nil and print usage on empty parameters.")do
        expect(CLI.parseCLIOptions([])).to eql(nil)
      end
      it("return nil and print a message on erronous file.")do
        expect(CLI.parseCLIOptions(["-f", "toto.csv"])).to eql(nil)
      end
      it("return a Config object on correct parameters.")do
        cfg = CLI.parseCLIOptions(["-f", "spec/fixtures/input.csv"])
        expect(cfg).to_not eql (nil)
      end
      it("return the same filename in Config than -f parameter.")do
        cfg = CLI.parseCLIOptions(["-f", "spec/fixtures/input.csv"])
        fname = cfg[:filename]
        expect(fname).to eql ("spec/fixtures/input.csv")
      end 
      it("return the same path as -f parameter if -o option if not defined.")do
        cfg = CLI.parseCLIOptions(["-f", "spec/fixtures/input.csv"])
        path = cfg[:outputPath]
        expect(path).to eql ("spec/fixtures/")
      end
    end
  end
  
  describe "validateAndBuildRooms" do
    context "given a list of rooms" do
      it("accept valid rooms, reject non-valid ones.") do
        expect(CLI.validateAndBuildRooms(['A', 'B', 'C', 'D', 'E', 'F'])).to eql (Challenge::ROOMS)
        expect(CLI.validateAndBuildRooms(['A', 'X', 'Z'])).to eql (["roomA"])
        expect(CLI.validateAndBuildRooms(['A', 'B', 'C'])).to eql (["roomA", "roomB", "roomC"])
        expect(CLI.validateAndBuildRooms(['E', 'VCVCB', '12374C'])).to eql (["roomE"])
      end
      it("return all rooms if all rooms are invalid or empty.") do
        expect(CLI.validateAndBuildRooms(['Z', 'VCVCB', '12374C'])).to eql (Challenge::ROOMS)
        expect(CLI.validateAndBuildRooms([])).to eql (Challenge::ROOMS)
      end 
    end
  end

  describe "validateDepartment" do
    it("accept a valid department")do
      expect(CLI.validateDepartment("HR1")).to eql ("HR1")
    end
    it("reject incorrect department")do
      expect(CLI.validateDepartment("HR12")).to eql ("")
    end 
  end

end
