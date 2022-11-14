module Dokku
  class App
    include ActiveModel::Model

    attr_reader :name

    class << self
      def all
        result = Ssh.new.exec("apps:list")
        return [] if result.match?("You haven't deployed any applications yet")

        result.split("\n").drop(1).sort.map do |app_name|
          new(name: app_name)
        end
      end

      def create(args)
        result = Ssh.new.exec("apps:create #{args[:name]}")

        app = new(args)
        if !result.match?("Creating")
          app.errors.add(:base, :invalid, message: result)
        end
        app
      end
    end

    def config
      result = Ssh.new.exec("config:show #{name}")

      if result.start_with?("=====>")
        result.split("\n").drop(1).sort.map do |line|
          line.match("(.*):\s+(.*)").captures
        end.to_h
      else
        {}
      end
    end

    def git_remote_name
      "dokku@#{ENV.fetch("DOKKU_HOST")}:#{name}"
    end

    def logs
      Ssh.new.exec("logs #{name}")
    end

    def save
      result = self.class.create(name: name)
      errors.merge!(result.errors)
      !errors.any?
    end

    def report
      @report ||= Ssh.new.exec("apps:report #{name}")
    end

    def name=(value)
      @name = value.strip
    end
  end
end
