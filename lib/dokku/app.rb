module Dokku
  class App
    include ActiveModel::Model

    attr_accessor :name

    class << self
      def all
        result = Command.new("2438801226e3dbc0e7b48716dba591071fa2f9a2c46d329cd10e67d3be3ffc30").run("apps:list")
        return [] if result.match?("You haven't deployed any applications yet")

        result.split("\n").drop(1).sort.map do |app_name|
          new(name: app_name)
        end
      end

      def create(args)
        result = Command.new("2438801226e3dbc0e7b48716dba591071fa2f9a2c46d329cd10e67d3be3ffc30").run("apps:create #{args[:name]}")

        app = new(args)
        if !result.match?("Creating")
          app.errors.add(:base, :invalid, message: result)
        end
        app
      end
    end

    def save
      result = self.class.create(name: name)
      errors.merge!(result.errors)
      !errors.any?
    end
  end
end
