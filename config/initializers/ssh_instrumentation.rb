ActiveSupport::Notifications.subscribe("ssh.exec") do |name, start, finish, id, payload|
  Rails.logger.info "SSH Exec `#{payload[:command]}` took #{finish - start} seconds"
end
