module Dokku
  class LogsController < ApplicationController
    def index
      @app = Dokku::App.new(name: params[:app_id])
    end
  end
end
