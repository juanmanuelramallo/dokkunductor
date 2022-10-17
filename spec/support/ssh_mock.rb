module SshMock
  class Base
    def initialize(result = nil)
      @result = result
    end
  end

  class Success < Base
    def exec(command)
      `exit 0`
      @result
    end
  end

  class Error < Base
    def exec(command)
      `exit 1`
      @result
    end
  end
end
