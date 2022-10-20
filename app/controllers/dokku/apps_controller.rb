module Dokku
  class AppsController < ApplicationController
    include CheckAccess

    # @route GET /dokku/apps (dokku_apps)
    # @route GET / (root)
    def index
      @apps = Dokku::App.all
      @app = Dokku::App.new
    end

    # @route POST /dokku/apps (dokku_apps)
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

    # @route GET /dokku/apps/:id (dokku_app)
    def show
      @app = Dokku::App.new(name: params[:id])
    end

    private

    def app_params
      params.require(:dokku_app).permit(:name)
    end
  end
end
