module Dokku
  class AppConfigsController < ApplicationController
    def show
      @app = Dokku::App.new(name: params[:app_id])
      @config = @app.config
    end

    def update
      @app = Dokku::App.new(name: params[:app_id])
      @config = @app.config

      configs = config_params.to_h
      new_name, new_value = configs.delete(:new_name), configs.delete(:new_value)
      configs.merge!(new_name => new_value) if new_name.present? && new_value.present?

      if @app.update_config(configs)
        redirect_to dokku_app_app_configs_path(app_id: @app.name), notice: "Config updated"
      else
        render :show, status: :see_other
      end
    end

    private

    def config_params
      params.require(:config).permit!
    end
  end
end
