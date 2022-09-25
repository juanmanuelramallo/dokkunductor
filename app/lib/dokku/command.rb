module Dokku
  class Command
    def initialize(container_id)
      @container_id = container_id
    end

    def run(command)
      `docker exec -t #{@container_id} dokku #{command}`
    end
  end
end
