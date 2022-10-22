module Menu
  extend ActiveSupport::Concern

  class Item
    include ActiveModel::API

    attr_accessor :name, :path
  end

  included do
    before_action :set_menu
  end

  def set_menu
    @menu = [
      Item.new(name: "Apps", path: dokku_apps_path),
      Item.new(name: "Postgres", path: dokku_postgres_path)
    ]
  end
end
