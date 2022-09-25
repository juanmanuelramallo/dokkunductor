module Dokku
  class LogsController < ApplicationController
    include CheckAccess

    def index
      @app = Dokku::App.new(name: params[:app_id])
    end
  end
end
