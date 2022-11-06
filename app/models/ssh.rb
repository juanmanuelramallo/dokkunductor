class Ssh
  include Turbo::Broadcastable

  class BroadcastModel
    def to_param
      "terminal"
    end
  end

  def model_name
    ActiveModel::Name.new(self, nil, "Ssh")
  end

  # Runs a command in the host machine
  #
  # Always uses localhost as the host. This works thanks to the host network mode for a docker container.
  # Localhost points to the host machine, not the docker container.
  # Does not use external IP address because after some successful ssh connections, new connections are refused.
  #
  # @param command [String] The command to run
  def exec(command)
    result = nil

    ActiveSupport::Notifications.instrument("ssh.exec", command: command) do
      Open3.popen2e("#{ssh_prefix} #{command}") do |_stdin, stdout_and_stderr, _wait_thr|
        result = stdout_and_stderr.read
      end
    end

    broadcast_result(command, result) unless command == "version"

    result
  end

  private

  def broadcast_result(command, result)
    broadcast_append_to BroadcastModel.new,
      target: "terminal",
      partial: "terminal/command",
      locals: {
        command: command,
        result: result,
        user: user
      }
  end

  def port
    ENV.fetch("DOKKU_PORT", 22)
  end

  def private_path
    ssh_key.private_path
  end

  def ssh_key
    SshKey.new
  end

  def ssh_prefix
    "ssh -o StrictHostKeyChecking=no -o PasswordAuthentication=no -i #{private_path} #{user}@#{host} -p #{port}"
  end

  def user
    "dokku"
  end

  def host
    Rails.env.production? ? "localhost" : ENV.fetch("DOKKU_HOST", "dokku.me")
  end
end
