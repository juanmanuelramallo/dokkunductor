module Dokku
  class Redis
    include ActiveModel::Model

    attr_reader :service

    class << self
      def all
        result = Ssh.new.exec("redis:list --quiet")
        return [] if result.match?("There are no redis services")

        result.split("\n").sort.map do |service|
          new(service: service)
        end
      end

      def create(args)
        result = Ssh.new.exec("redis:create #{args[:service]} #{args[:flags]}")

        redis = new(args)
        if !result.match?("Redis container created")
          redis.errors.add(:base, :invalid, message: result)
        end
        redis
      end
    end

    def service=(value)
      @service = value.strip
    end

    def info
      Ssh.new.exec("redis:info #{service}")
    end

    def links
      result = Ssh.new.exec("redis:links #{service}")
      result.split("\n")
    end

    def link(app_name)
      Ssh.new.exec("redis:link #{service} #{app_name} &") # & to run in background

      true
    end

    def save
      result = self.class.create(service: service)
      errors.merge!(result.errors)
      !errors.any?
    end

    def destroy
      result = Ssh.new.exec("redis:destroy #{service} --force")

      if !result.match?("Redis container deleted")
        errors.add(:base, :invalid, message: result.strip)
      end
      !errors.any?
    end

    def to_param
      service
    end
  end
end
