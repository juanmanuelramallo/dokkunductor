module Dokku
  class AppLogsController < ApplicationController
    include CheckAccess

    def index
      @app = Dokku::App.new(name: params[:app_id])
    end
  end
end
