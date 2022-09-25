module Dokku
  class App
    include ActiveModel::Model

    attr_accessor :name

    class << self
      def all
        result = Command.new.run("apps:list")
        return [] if result.match?("You haven't deployed any applications yet")

        result.split("\n").drop(1).sort.map do |app_name|
          new(name: app_name)
        end
      end

      def create(args)
        result = Command.new.run("apps:create #{args[:name]}")

        app = new(args)
        if !result.match?("Creating")
          app.errors.add(:base, :invalid, message: result)
        end
        app
      end
    end

    def logs
      Command.new.run("logs #{name}")
    end

    def save
      result = self.class.create(name: name)
      errors.merge!(result.errors)
      !errors.any?
    end

    def report
      @report ||= Command.new.run("apps:report #{name}")
    end

    def name=(value)
      @name = value.strip
    end
  end
end
