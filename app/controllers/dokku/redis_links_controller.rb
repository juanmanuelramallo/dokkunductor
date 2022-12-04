module Dokku
  class RedisLinksController < ApplicationController
    # @route GET /dokku/redis_services/:redis_service_name/redis_links/new (new_dokku_redis_service_links)
    def new
      @redis = Redis.new(service: params[:redis_service_name])
      @available_app_names = Dokku::App.all.map(&:name) - @redis.links
    end

    # @route POST /dokku/redis_services/:redis_service_name/redis_links (dokku_redis_service_links)
    def create
      @redis = Redis.new(service: params[:redis_service_name])

      if @redis.link(link_params[:app_name])
        redirect_to dokku_redis_service_path(@redis)
      else
        @available_app_names = Dokku::App.all.map(&:name) - @redis.links
        render :new
      end
    end

    private

    def link_params
      params.require(:redis_link).permit(:app_name)
    end
  end
end
