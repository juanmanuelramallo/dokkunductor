module Dokku
  class AppConfigsController < ApplicationController
    def show
      @app = Dokku::App.new(name: params[:app_id])
      @config = @app.config
    end

    def update
      @app = Dokku::App.new(name: params[:app_id])
      @config = @app.config

      if @app.update_config(flattened_config)
        redirect_to dokku_app_app_configs_path(app_id: @app.name), notice: "Config updated"
      else
        render :show, status: :see_other
      end
    end

    private

    def config_params
      params.require(:config).permit!
    end

    def flattened_config
      @flattened_config ||= begin
        configs = config_params.to_h
        new_name, new_value = configs.delete(:new_name), configs.delete(:new_value)
        configs.merge!(new_name => new_value) if new_name.present? && new_value.present?
        configs
      end
    end
  end
end
