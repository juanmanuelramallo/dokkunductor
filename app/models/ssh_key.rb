class SshKey
  include ActiveModel::Model

  KEY_TYPE = "ed25519".freeze
  FILE_NAME = "dokkunductor_id_#{KEY_TYPE}".freeze

  attr_reader :result

  def command
    <<~BASH
      dokku ssh-keys:remove dokkunductor # If the key already exists\n
      echo "#{public_key}" | dokku ssh-keys:add dokkunductor\n
      mkdir ~/.ssh\n
      echo "#{public_key}" > ~/.ssh/authorized_keys\n
    BASH
  end

  def save
    return true if public_key?

    @result = `ssh-keygen -t #{KEY_TYPE} -N "" -C "dokkunductor" -f #{private_path}`

    $?.success?
  end

  def destroy
    `rm -rf #{private_path}*`
  end

  def public_key?
    File.exist?(persistent_path.join(pub_path.to_s))
  end

  def public_key
    File.read(persistent_path.join(pub_path.to_s)).strip
  end

  def accessible?
    result = Ssh.new.exec("version")

    result.match?("dokku version")
  end

  def pub_path
    persistent_path.join("#{FILE_NAME}.pub")
  end

  def private_path
    persistent_path.join(FILE_NAME)
  end

  private

  def persistent_path
    Rails.root.join(ENV.fetch("PERSISTENT_PATH"))
  end
end
