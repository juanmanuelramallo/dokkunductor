module Dokku
  class AppsController < ApplicationController
    include CheckAccess

    def index
      @apps = Dokku::App.all
      @app = Dokku::App.new
    end

    def create
      @app = Dokku::App.new(app_params)

      if @app.save
        redirect_to dokku_apps_path, notice: "#{@app.name} was successfully created."
      else
        @apps = Dokku::App.all
        Rails.logger.info @app.errors.full_messages.inspect
        render :index, status: :see_other
      end
    end

    def show
      @app = Dokku::App.new(name: params[:id])
    end

    private

    def app_params
      params.require(:dokku_app).permit(:name)
    end
  end
end
