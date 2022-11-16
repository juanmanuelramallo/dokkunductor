module Dokku
  class AppConfigsController < ApplicationController
    # @route GET /dokku/apps/:app_id/app_configs (dokku_app_app_configs)
    def show
      @app = Dokku::App.new(name: params[:app_id])
      @config = @app.config
    end

    # @route PATCH /dokku/apps/:app_id/app_configs (dokku_app_app_configs)
    # @route PUT /dokku/apps/:app_id/app_configs (dokku_app_app_configs)
    def update
      @app = Dokku::App.new(name: params[:app_id])
      @config = @app.config

      if @app.update_config(configs_to_update) && @app.unset_config(configs_to_unset)
        redirect_to dokku_app_app_configs_path(app_id: @app.name), notice: "Config updated"
      else
        render :show, status: :see_other
      end
    end

    private

    def config_params
      params.require(:config).permit!
    end

    def configs_to_update
      config_params.to_h
        .values
        .select { |config| config["delete"] == "0" && config["name"].present? }
        .to_h { |config| [config["name"], config["value"]] }
    end

    def configs_to_unset
      config_params.to_h
        .values
        .select { |config| config["delete"] == "1" && config["name"].present? }
        .map { |config| config["name"] }
    end
  end
end
