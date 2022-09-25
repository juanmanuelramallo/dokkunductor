module CheckAccess
  extend ActiveSupport::Concern

  included do
    before_action :check_access!
  end

  private

  def check_access!
    ssh_key = SshKey.new

    if !ssh_key.accessible?
      redirect_to new_ssh_key_path, alert: "SSH key is not added to Dokku"
    end
  end
end
