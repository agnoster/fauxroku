require 'thor'
require 'fauxroku/app'
require 'fauxroku/buildpack'

module Fauxroku
  class CLI < Thor
    class_option :app, :aliases => "-a", :desc => "Name of the app"

    desc "create", "set up a new app"
    def create
      say "-----> Creating app #{app.name}"
      app.create
    end

    desc "deploy HASH", "deploy the app"
    def deploy(hash)
      say "-----> Deploying revision #{hash}"
      app.deploy hash
    end

    desc "delete", "delete the app"
    def delete
      say "-----> Detected deletion of app #{app.name}"
      app.delete
      say "-----> App deleted"
    end

    desc "update HASH", "process the git hook"
    def update(hash)
      say "-----> Received push to #{app.name}"
      if hash == "0000000000000000000000000000000000000000"
        delete
      else
        deploy hash
      end
    end

    desc "build DIR", "build the application"
    def build(dir)
      app.load_code dir
      Fauxroku::Buildpack.detect(app.work_dir).tap do |buildpack|
        say "Detected: #{buildpack.detected}"
        buildpack.compile app.work_dir, app.cache_dir
      end
    end

    desc "buildpacks", "fetch the builtin buildpacks"
    def buildpacks
      say "Fetching builtin buildpacks"
      Fauxroku::Buildpack.fetch_builtin
      say "All done!"
    end

    private

    def app
      App.new options[:app]
    end
  end
end
