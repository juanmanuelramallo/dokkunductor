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
    end

    def service=(value)
      @service = value.strip
    end

    def info
      Ssh.new.exec("postgres:info #{service}")
    end
  end
end
