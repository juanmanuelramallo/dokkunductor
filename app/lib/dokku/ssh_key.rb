module Dokku
  class SshKey
    include ActiveModel::Model

    attr_accessor :info

    class << self
      def all
        result = Ssh.new.exec("ssh-keys:list")

        result.split("\n").sort.map do |text|
          new(info: text)
        end
      end
    end
  end
end
