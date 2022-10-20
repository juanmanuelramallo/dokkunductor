module Dokku
  class PostgresController < ApplicationController
    include CheckAccess

    # @route GET /dokku/postgres (dokku_postgres)
    def index
      @postgres_services = Postgres.all
    end

    # @route GET /dokku/postgres/new (new_dokku_postgre)
    def new
      @postgres = Postgres.new
    end

    # @route POST /dokku/postgres (dokku_postgres)
    def create
      @postgres = Postgres.new(postgres_params)
      if @postgres.save
        redirect_to dokku_postgres_path(@postgres)
      else
        render :new
      end
    end

    # @route GET /dokku/postgres/:service (dokku_postgre)
    def show
      @postgres = Postgres.new(service: params[:service])
    end

    private

    def postgres_params
      params.require(:postgres).permit(:service, :flags)
    end
  end
end
