module Dokku
  class Postgres
    include ActiveModel::Model

    attr_accessor :service

    class << self
      def all
        result = Ssh.new.exec("postgres:list --quiet")
        return [] if result.match?("There are no Postgres services")

        result.split("\n").sort.map do |service|
          new(service: service)
        end
      end

      def create(args)
        result = Ssh.new.exec("postgres:create #{args[:service]} #{args[:flags]}")

        postgres = new(args)
        if !result.match?("Postgres container created")
          postgres.errors.add(:base, :invalid, message: result)
        end
        postgres
      end
    end

    def service=(value)
      @service = value.strip
    end

    def info
      Ssh.new.exec("postgres:info #{service}")
    end

    def save
      result = self.class.create(service: service)
      errors.merge!(result.errors)
      !errors.any?
    end

    def destroy
      result = Ssh.new.exec("postgres:destroy #{service} --force")

      if !result.match?("Postgres container deleted")
        errors.add(:base, :invalid, message: result.strip)
      end
      !errors.any?
    end

    def to_param
      service
    end
  end
end
