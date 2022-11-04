module Dokku
  class PostgresLinksController < ApplicationController
    def new
      @postgres = Postgres.new(service: params[:postgre_service])
      @available_app_names = Dokku::App.all.map(&:name) - @postgres.links
    end

    def create
      @postgres = Postgres.new(service: params[:postgre_service])

      if @postgres.link(link_params[:app_name])
        redirect_to dokku_postgre_path(@postgres)
      else
        @available_app_names = Dokku::App.all.map(&:name) - @postgres.links
        render :new
      end
    end

    private

    def link_params
      params.require(:postgres_link).permit(:app_name)
    end
  end
end
