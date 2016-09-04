require "worker"

describe Worker do

  # 
  resultHR3RoomA = ['HR3;2009-01-20;19;HALO;OPEC','HR3;2009-01-21;21;;']
  resultHR3RoomB = ['HR3;2009-01-20;4;HALO;OPEC','HR3;2009-01-19;5;HALO;EUR','HR3;2009-01-21;89;;']
  resultHR3RoomC = ['HR3;2009-01-20;3;HALO;OPEC','HR3;2009-01-19;3;HALO;EUR','HR3;2009-01-21;56;;']

  #
  let(:input) { File.realdirpath "spec/fixtures/input.csv" } 
  let(:folder) { File.dirname(File.realdirpath 'spec/fixtures/input.csv') + File::Separator} 
  let(:invalid) { File.realdirpath 'spec/fixtures/invalid.csv'}

  # cleanup folder for tests consistancy 
  def cleanupTestFiles
    ('A' .. 'F').each { |del| FileUtils.rm("#{folder}HR3-Room#{del}.csv", force: true) } 
  end

  describe "process" do
    
    it("throw an exception on non-existant filename path.") do
      expect {
        Worker.process("tator.csv", "", ["roomA", "roomB"], "")
      }.to raise_error (/No such file or directory/)    
    end
    
    it("throw an exception on invalid structure in input file.") do
      expect {
        Worker.process(invalid, "HR3", ["roomA", "roomB"], folder)
      }.to raise_error (WorkerException)
    end
    
    it("return the correct values for HR3, RoomA.") do
      cleanupTestFiles
      Worker.process(input, "HR3", ["roomA"], folder)
      expect(File.new(folder+"HR3-RoomA.csv").readlines.map(&:strip)).to eql (resultHR3RoomA)
    end

    it("return the correct values for HR3, RoomB.") do
      Worker.process(input, "HR3", ["roomB"], folder)
      expect(File.readlines(folder+"HR3-RoomB.csv").map(&:strip)).to eql (resultHR3RoomB)
    end
    
    it("return the correct values for HR3, RoomC.") do
      Worker.process(input, "HR3", ["roomC"], folder)
      expect(File.readlines(folder+"HR3-RoomC.csv").map(&:strip)).to eql (resultHR3RoomC) 
    end
    
    it("create all HR3 rooms files with the HR3 department filter.") do
      cleanupTestFiles
      Worker.process(input, "HR3", Challenge::ROOMS, folder)
      # all files should be created... 
      existance = ('A' .. 'F')
                  .map { |r| (File.exists?(folder+"HR3-Room#{r}.csv"))}
                  .inject(true) {|acc, ex| acc && ex }
      expect(existance).to eql (true)
      # final cleanup
      cleanupTestFiles
    end
  end
end

