require "fauxroku/version"

# Public: Fauxroku allows you to build and run heroku apps in a variety of
# environments. It provides
#  - a CLI tool (using Thor)
#  - an interface to Buildpacks
#  - a representation of Apps
module Fauxroku
  # Public: Get the fauxroku directory from path parts, and ensure the
  # directory exists.
  #
  # Returns a String representing the path to the directory
  def self.dir(*parts)
    @@dirs ||= {}
    path = File.join(ENV['HOME'], ".fauxroku", *parts)
    @@dirs[path] ||= path.tap do |dir|
      FileUtils.mkdir_p dir unless File.exists? dir
    end
  end
end
