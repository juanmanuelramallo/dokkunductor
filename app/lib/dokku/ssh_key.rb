module Dokku
  class SshKey
    include ActiveModel::Model

    attr_accessor :info, :name, :public_key

    class << self
      def all
        result = Ssh.new.exec("ssh-keys:list")

        result.split("\n").sort.map do |text|
          new(info: text)
        end
      end

      # @param args [Hash]
      #   - :name [String] The name of the key
      #   - :public_key [String] The public key
      def create(args)
        result = Ssh.new.exec("echo \"#{args[:public_key]}\" | ssh-keys:add #{args[:name]}")

        ssh_key = new(name: args[:name], public_key: args[:public_key])
        if result.include?("!")
          ssh_key.errors.add(:base, result)
        else
          ssh_key.info = result
        end
        ssh_key
      end
    end
  end
end
