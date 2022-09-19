module Dokku
  class AppsController < ApplicationController
    def index
      @apps = Dokku::App.all
    end
  end
end
