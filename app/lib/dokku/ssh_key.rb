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
        result = Ssh.new.exec("dokku ssh-keys:add #{args[:name]}", root: true) do |stdin|
          stdin.puts(args[:public_key])
        end

        ssh_key = new(name: args[:name], public_key: args[:public_key])
        if result.include?("!")
          ssh_key.errors.add(:base, result)
        else
          ssh_key.info = result
        end
        ssh_key
      end
    end

    def save
      result = self.class.create(name: name, public_key: public_key)
      errors.merge!(result.errors)
      !errors.any?
    end
  end
end
