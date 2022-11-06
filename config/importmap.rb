# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.1.0
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
# pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from File.expand_path("../app/javascript/controllers", __dir__), under: "controllers"
pin "stimulus-clipboard" # @3.2.0
pin "stimulus-notification" # @2.1.0
pin "hotkeys-js" # @3.10.0
pin "stimulus-use" # @0.50.0
