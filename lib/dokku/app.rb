module Dokku
  class App
    def self.all
      result = Command.new("2438801226e3dbc0e7b48716dba591071fa2f9a2c46d329cd10e67d3be3ffc30").run("apps:list")
      return [] if result.match?("You haven't deployed any applications yet")

      result.split("\n").drop(1).sort.map do |app|
        new(app)
      end
    end

    attr_accessor :name

    def initialize(name)
      @name = name
    end
  end
end
