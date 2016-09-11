require 'spec_helper'

describe Walle do
  describe Walle::Placeholders do
    
    before :each do
      @name = "test"
      @domain = "com.company.example"
      @placeholders = Walle::Placeholders.new(
        :project_name => @name,
        :company_domain => @domain
      )
    end

    describe "#new" do
      context "when initialized with invalid args" do

        it "raises an exception" do
          expect{ Walle::Placeholders.new({}) }.to raise_error(ArgumentError)
          expect{ Walle::Placeholders.new :project_name => "" }.to raise_error(ArgumentError)
          expect{ Walle::Placeholders.new :company_domain => "" }.to raise_error(ArgumentError)
        end

      end

      context "when initialized with valid args" do

        it "creates a valid object" do
          expect(@placeholders).not_to be_nil
          expect(@placeholders.project_name).to eql @name
          expect(@placeholders.company_domain).to eql @domain
        end

      end

    end

    describe "#copy" do

      after :each do
        clear_temporary_dir
      end

      it "replace placeholders and copy template file to destination" do
        @placeholders.copy(template_source, template_destination)
        expect(File.exist?(template_destination)).to be_truthy
      end

    end

    describe "#replace" do

      it "replace placeholders with values" do
        result = @placeholders.replace(test_contents)
        expect(result).to eql expected_contents
      end

    end

  end
end


# Helper functions

def test_contents
  "Here stays COMPANY_DOMAIN and here will stay PROJECT_NAME."
end

def expected_contents
  "Here stays com.company.example and here will stay test."
end

def template_source
  path = File.join(temporary_dir, 'template.txt')
  
  unless File.exist?(path)
    test_contents.write_to_file(path)
  end

  path
end

def template_destination
  File.join(temporary_dir, 'destination', 'template.txt')
end
