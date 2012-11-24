require "fauxroku/version"

# Public: Fauxroku allows you to build and run heroku apps in a variety of
# environments. It provides
#  - a CLI tool (using Thor)
#  - an interface to Buildpacks
#  - a representation of Apps
module Fauxroku
  def self.dir(*path)
    File.join(ENV['HOME'], ".fauxroku", *path).tap do |dir|
      FileUtils.mkdir_p dir
    end
  end
end
