class SshKeysController < ApplicationController
  # @route GET /ssh_key/new (new_ssh_key)
  def new
    @ssh_key = SshKey.new

    if @ssh_key.public_key?
      redirect_to ssh_key_path, notice: "SSH key already exists"
    end
  end

  # @route POST /ssh_key (ssh_key)
  def create
    @ssh_key = SshKey.new

    if @ssh_key.save
      redirect_to ssh_key_path, notice: "SSH key created"
    else
      render :new
    end
  end

  # @route GET /ssh_key (ssh_key)
  def show
    @ssh_key = SshKey.new

    if !@ssh_key.public_key?
      redirect_to new_ssh_key_path, notice: "SSH key does not exist"
    elsif @ssh_key.accessible?
      redirect_to dokku_apps_path, notice: "SSH key is already added to Dokku"
    end
  end

  # @route DELETE /ssh_key (ssh_key)
  def destroy
    @ssh_key = SshKey.new

    @ssh_key.destroy
    redirect_to new_ssh_key_path, notice: "SSH key deleted"
  end
end
