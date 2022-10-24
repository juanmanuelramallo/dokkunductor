class Ssh
  # Runs a command in the host machine
  #
  # Always uses localhost as the host. This works thanks to the host network mode for a docker container.
  # Localhost points to the host machine, not the docker container.
  # Does not use external IP address because after some successful ssh connections, new connections are refused.
  #
  # @param command [String] The command to run
  def exec(command)
    ActiveSupport::Notifications.instrument("ssh.exec", command: command) do
      Open3.popen2e("#{ssh_prefix} #{command}") do |_stdin, stdout_and_stderr, _wait_thr|
        stdout_and_stderr.read
      end
    end
  end

  private

  def private_path
    ssh_key.private_path
  end

  def ssh_key
    SshKey.new
  end

  def ssh_prefix
    "ssh -o StrictHostKeyChecking=no -o PasswordAuthentication=no -i #{private_path} #{user}@#{host}"
  end

  def user
    "dokku"
  end

  def host
    Rails.env.production? ? "localhost" : "dokku.me"
  end
end
