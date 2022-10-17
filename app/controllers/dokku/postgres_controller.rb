module Dokku
  class PostgresController < ApplicationController
    include CheckAccess

    def index
      @postgres_services = Postgres.all
    end

    def new
      @postgres = Postgres.new
    end

    def create
      @postgres = Postgres.new(postgres_params)
      if @postgres.save
        redirect_to dokku_postgres_path(@postgres)
      else
        render :new
      end
    end

    def show
      @postgres = Postgres.new(service: params[:service])
    end

    private

    def postgres_params
      params.require(:postgres).permit(:service, :flags)
    end
  end
end
