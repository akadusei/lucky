module GeneratorHelper
  private def should_create_files_with_contents(io : IO, **files_and_contents)
    files_and_contents.each do |file_location, file_contents|
      File.read(file_location.to_s).should contain(file_contents)
      io.to_s.should contain(file_location.to_s)
    end
  end

  private def should_generate_migration(named name : String)
    Dir.new("./db/migrations").any?(&.ends_with?(name)).should be_true
  end
end
