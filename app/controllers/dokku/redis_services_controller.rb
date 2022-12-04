module Dokku
  class RedisServicesController < ApplicationController
    # @route GET /dokku/redis_services (dokku_redis_services)
    def index
      @redis_services = Dokku::Redis.all
      @redis = Dokku::Redis.new
    end

    # @route POST /dokku/redis_services (dokku_redis_services)
    def create
      @redis = Dokku::Redis.new(redis_params)
      if @redis.save
        redirect_to dokku_postgre_path(service: @redis.service)
      else
        @redis_services = redis.all
        render :index, status: :see_other
      end
    end

    # @route GET /dokku/redis_services/:name (dokku_redis_service)
    def show
      @redis = Dokku::Redis.new(service: params[:name])
    end

    # @route DELETE /dokku/redis_services/:name (dokku_redis_service)
    def destroy
      @redis = Dokku::Redis.new(service: params[:name])

      if @redis.destroy
        redirect_to dokku_redis_path, status: :see_other
      else
        render :show, status: :see_other
      end
    end

    private

    def redis_params
      params.require(:dokku_redis).permit(:service, :flags)
    end
  end
end
