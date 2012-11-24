require 'fileutils'
require 'pathname'
require 'fauxroku'

module Fauxroku
  class App < Struct.new(:name)
    def create
      system({ "PWD" => git_dir }, "git init --bare")
      # template "git-hooks/update.tt", "#{git_dir}/git-hooks"
    end

    def git_dir
      Fauxroku.dir 'git', "#{name}.git"
    end

    def work_dir
      Fauxroku.dir 'snapshots', name, snapshot
    end

    def cache_dir
      Fauxroku.dir 'cache', name
    end

    # Public: Load the code from dir into the work_dir
    def load_code(dir)
      FileUtils.rm_rf File.join(work_dir, '*')
      files = `cd #{dir}; git ls-files`.split($/)

      # make dirs
      files.map {|f| Pathname.new(f).dirname }.uniq.each do |d|
        FileUtils.mkdir_p File.join(work_dir, d)
      end

      files.each do |f|
        FileUtils.cp File.join(dir, f), File.join(work_dir, f)
      end
    end

    def git_files(dir)
    end

    def snapshot
      @hash || 'snapshot'
    end
  end
end
