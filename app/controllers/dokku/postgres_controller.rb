module Dokku
  class PostgresController < ApplicationController
    include CheckAccess

    # @route GET /dokku/postgres (dokku_postgres)
    def index
      @postgres_services = Postgres.all
      @postgres = Postgres.new
    end

    # @route POST /dokku/postgres (dokku_postgres)
    def create
      @postgres = Postgres.new(postgres_params)
      if @postgres.save
        redirect_to dokku_postgre_path(service: @postgres.service)
      else
        @postgres_services = Postgres.all
        render :index, status: :see_other
      end
    end

    # @route GET /dokku/postgres/:service (dokku_postgre)
    def show
      @postgres = Postgres.new(service: params[:service])
    end

    def destroy
      @postgres = Postgres.new(service: params[:service])

      if @postgres.destroy
        redirect_to dokku_postgres_path, status: :see_other
      else
        render :show, status: :see_other
      end
    end

    private

    def postgres_params
      params.require(:dokku_postgres).permit(:service, :flags)
    end
  end
end
