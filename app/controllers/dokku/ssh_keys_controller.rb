module Dokku
  class SshKeysController < ApplicationController
    # @route GET /dokku/ssh_keys (dokku_ssh_keys)
    def index
      @ssh_key = Dokku::SshKey.new
      @ssh_keys = Dokku::SshKey.all
    end

    # @route POST /dokku/ssh_keys (dokku_ssh_keys)
    def create
      @ssh_key = Dokku::SshKey.new(ssh_key_params)

      if @ssh_key.save
        redirect_to dokku_ssh_keys_path, notice: "#{@ssh_key.name} was successfully created."
      else
        @ssh_keys = Dokku::SshKey.all
        Rails.logger.info @ssh_key.errors.full_messages.inspect
        render :index, status: :see_other
      end
    end

    private

    def ssh_key_params
      params.require(:dokku_ssh_key).permit(:name, :public_key)
    end
  end
end
