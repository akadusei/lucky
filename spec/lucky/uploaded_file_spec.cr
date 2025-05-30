require "../spec_helper"

include ContextHelper
include MultipartHelper

describe Lucky::UploadedFile do
  describe "#name" do
    it "returns the form data part name" do
      uploaded_file.name.should eq("welcome_file")
    end
  end

  describe "#tempfile" do
    it "returns the tempfile" do
      uploaded_file.tempfile.should be_a(File)
    end

    it "can be read" do
      uploaded_file.tempfile.gets_to_end.should eq("welcome file contents")
    end
  end

  describe "#path" do
    it "returns the file path" do
      uploaded_file.path.starts_with?(Dir.tempdir).should be_true
      uploaded_file.path.ends_with?("welcome_file").should be_true
    end
  end

  describe "#filename" do
    it "returns the original file from the metadata object" do
      uploaded_file.filename.should eq("welcome_file")
    end

    it "generates random filename for files without names" do
      nameless_uploaded_file.filename.should_not be_empty
    end
  end

  describe "#blank?" do
    it "tests if the file name is blank" do
      uploaded_file.blank?.should be_false
      empty_uploaded_file.blank?.should be_true
    end
  end
end

private def empty_uploaded_file
  Lucky::Params.new(build_multipart_request(file_parts: {
    "empty_file" => "",
  })).get_file(:empty_file)
end

private def nameless_uploaded_file
  Lucky::Params.new(build_multipart_request(file_parts: {
    "" => "nameless file contents",
  })).from_multipart[1][""]
end

private def uploaded_file
  Lucky::Params.new(build_multipart_request(file_parts: {
    "welcome_file" => "welcome file contents",
  })).get_file(:welcome_file)
end
