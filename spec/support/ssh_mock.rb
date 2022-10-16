module SshMock
  class Success
    def exec(command)
      `exit 0`
    end
  end

  class Error
    def exec(command)
      `exit 1`
    end
  end
end
