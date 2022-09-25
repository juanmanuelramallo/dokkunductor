ActiveSupport::Notifications.subscribe("dokku.command") do |name, start, finish, id, payload|
  Rails.logger.info "Dokku command `#{payload[:command]}` took #{finish - start} seconds"
end
