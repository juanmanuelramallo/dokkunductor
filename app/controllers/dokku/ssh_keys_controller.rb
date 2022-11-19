module Dokku
  class SshKeysController < ApplicationController
    # @route GET /dokku/ssh_keys (dokku_ssh_keys)
    def index
      @ssh_keys = Dokku::SshKey.all
    end
  end
end
