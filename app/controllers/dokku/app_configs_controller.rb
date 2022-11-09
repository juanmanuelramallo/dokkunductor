module Dokku
  class AppConfigsController < ApplicationController
    def show
      @app = Dokku::App.new(name: params[:app_id])
      @config = @app.config
    end
  end
end
