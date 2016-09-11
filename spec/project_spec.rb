require 'spec_helper'

describe Walle do
  describe Walle::Project do

    describe "#new" do
      context "when initialized with invalid name" do

        it "raises an exception" do
          expect{ Walle::Project.new({}) }.to raise_error(ArgumentError)
          expect{ Walle::Project.new :project_name => "" }.to raise_error(ArgumentError)
        end

      end

      context "when initialized with valid name" do

        it "creates a valid object" do
          name = "test"
          project = Walle::Project.new :project_name => name

          expect(project).not_to be_nil
          expect(project.project_name).to eql name
          expect(project.path).not_to be_nil
          expect(project.company_domain).not_to be_nil
        end
      end

    end

    describe "#generate" do 
      
      before :each do
        @project_name = "test"
        @company_domain = "com.company.example"

        @project = Walle::Project.new(
          :project_name => @project_name,
          :location => temporary_dir,
          :company_domain => @company_domain
          )
      end

      after :each do
        clear_temporary_dir
      end

      it "generates project folder" do
        @project.generate()

        expect(directory_contains_subdir(temporary_dir, @project_name)).to be_truthy
      end

      it "generates project structure" do
        @project.generate()
        
        contains_subdirectories = ['bin', 'docs', 'lib', 'obj', 'res', 'src'].all? { |subdir|
          directory_contains_subdir(@project.path, subdir)
        }

        expect(contains_subdirectories).to be_truthy
      end

      it "copies template files" do
        @project.generate()

        files = [
          'AndroidManifest.xml',
          'build.walle',
          'res/values/strings.xml',
          'src/com/company/example/test/Test.java',
          'res/drawable/icon.png',
        ]
        contains_files = files.all? { |file|
          directory_contains_file(@project.path, file)
        }
        expect(contains_files).to be_truthy
      end

    end

  end
end

def directory_contains_subdir(dir, subdir)
  path = File.join(dir, subdir)
  return false if path.nil?
  Dir.exist?(path)
end

def directory_contains_file(dir, file)
  path = File.join(dir, file)
  return false if path.nil?
  File.exist?(path)
end
