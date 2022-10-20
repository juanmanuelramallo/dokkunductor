module Dokku
  class AppLogsController < ApplicationController
    include CheckAccess

    # @route GET /dokku/apps/:app_id/app_logs (dokku_app_app_logs)
    def index
      @app = Dokku::App.new(name: params[:app_id])
    end
  end
end
