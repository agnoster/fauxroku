require 'fauxroku'

module Fauxroku
  # Public: A Buildpack represents a heroku buildpack (see
  # https://devcenter.heroku.com/articles/buildpacks). A buildpack can be
  # downloaded from git or sourced locally.
  class Buildpack < Struct.new(:name)

    # Public: List of default buildpacks
    BUILTIN_BUILDPACKS = %w{ruby nodejs clojure python java gradle grails scala play}

    # Public: The external source to fetch a buildpack from
    attr_writer :uri
    attr_writer :dir
    attr_reader :detected

    # Public: Get the uri of the buildpack, default to the heroku buildpack
    def uri
      @uri ||= "git://github.com/heroku/heroku-buildpack-#{name}.git"
    end

    # Public: Get the dir of the buildpack, default to the buildpack cache
    def dir
      @dir ||= File.join Buildpack.cache_dir, name
    end

    # Public: Download the buildpack from a specific location
    def download(source=nil)
      source ||= uri or raise ArgumentError, "Unsure where to fetch buildpack #{dir} from"
      system("git clone '#{source}' '#{dir}'")
    end

    # Public: Update the buildpack. If it's a git repo, just `git pull origin`
    def update(source=nil)
      source ||= (uri || "origin")
      system({
        'GIT_DIR' => File.join(dir, '.git'),
        'GIT_WORK_TREE' => dir
      }, "git pull '#{source}'")
    end

    # Public: Does the buildpack exist locally?
    def exists?
      File.exists? dir
    end

    # Public: Download the buildpack if it doesn't yet exist, otherwise update it.
    def fetch(source=nil)
      if exists?
        update(source)
      else
        download(source)
      end
    end

    # Public: Detect if the buildpack is appropriate for the given app
    #
    # Returns the name of the buildpack to be used if matching, nil otherwise
    def detect(dir)
      buildpack = `#{command :detect, dir}`
      @detected = buildpack if $?.success?
    end

    # Public: Compile the application
    def compile(dir, cache)
      system command(:compile, dir, cache)
    end

    # Public: The directory where the buildpacks are stored
    def self.cache_dir
      Fauxroku.dir 'buildpacks'
    end

    # Public: Download the default buildpacks
    def self.fetch_builtin
      self.builtin.each do |buildpack|
        buildpack.fetch
      end
    end

    # Public: Detect which default buildpack should run for a given app
    def self.detect(dir)
      Buildpack.builtin.detect do |buildpack|
        buildpack.detect dir
      end
    end

    def self.builtin
      @builtin ||= BUILTIN_BUILDPACKS.map do |name|
        Buildpack.new(name)
      end
    end

    private

    # Internal: Build up a command to run a given buildpack script.
    #
    # Returns a String ready for passing to system, exec, etc.
    def command(script, *args)
      "cd '#{dir}' && bin/#{script} #{args.map{|a| "'#{a}'"}.join(' ')}"
    end
  end
end
