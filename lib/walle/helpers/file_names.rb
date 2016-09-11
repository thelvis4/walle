module Walle

  class FileName

    def self.manifest
      'AndroidManifest.xml'
    end

    def self.build_configuration
      'build.walle'
    end

    def self.strings
      'strings.xml'
    end

    def self.source_template
      'Source.java'
    end

  end

  class DirectoryName

    def self.templates
      'templates'
    end

    def self.src
      'src'
    end

    def self.res
      'res'
    end

    def self.drawable
      'drawable'
    end

    def self.layout
      'layout'
    end

    def self.values
      'values'
    end

    def self.obj
      'obj'
    end

    def self.lib
      'lib'
    end

    def self.bin
      'bin'
    end

    def self.docs
      'docs'
    end

  end

end
