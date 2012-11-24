require 'fileutils'
require 'fauxroku'

module Fauxroku
  class App < Struct.new(:name)
    def create
      system({ "PWD" => git_dir }, "git init --bare")
      # template "git-hooks/update.tt", "#{git_dir}/git-hooks"
    end

    def git_dir
      Fauxroku.dir name, "#{name}.git"
    end

    def work_dir
      Fauxroku.dir name, snapshot
    end

    def cache_dir
      Fauxroku.dir name, :cache
    end

    def snapshot
      @hash || 'snapshot'
    end
  end
end
