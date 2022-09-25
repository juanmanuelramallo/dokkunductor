module Dokku
  class Command
    # @param host [String] The host to run the command on (i.e. dokku.me). Defaults to ENV['DOKKU_HOST']
    def initialize(host = nil)
      @host = host || ENV.fetch("DOKKU_HOST")
    end

    def run(command)
      ActiveSupport::Notifications.instrument("dokku.command", command: command) do
        `ssh dokku@#{@host} #{command}`
      end
    end
  end
end
