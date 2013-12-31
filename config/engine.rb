require 'rails'

# An engine doesn't require it's own dependencies automatically. We also don't
# want the applications to have to do that.
require 'cancan'
require 'authlogic'
require 'kaminari'
require 'iq_rdf'
require 'json'
require 'rails_autolink'
require 'simple_form'
require 'sass'
require 'sass-rails'
require 'bootstrap-sass'
require 'protected_attributes'
require 'font-awesome-rails'
require 'uglifier'
require 'apipie-rails'
require 'database_cleaner'
require 'delayed_job_active_record'

require 'iqvoc/controller_extensions'

module Iqvoc

  class Engine < Rails::Engine
    paths["lib/tasks"] << "lib/engine_tasks"

    initializer "iqvoc.mixin_controller_extensions" do |app|
      if Kernel.const_defined?(:ApplicationController)
        ApplicationController.send(:include, Iqvoc::ControllerExtensions)
      end
    end

    initializer "iqvoc.add_assets_to_precompilation" do |app|
      app.config.assets.precompile += Iqvoc.core_assets
    end

    initializer "iqvoc.load_migrations" do |app|
      # Pull in all the migrations to the application embedding iqvoc
      app.config.paths['db/migrate'].concat(Iqvoc::Engine.paths['db/migrate'].existent)
    end

    initializer "iqvoc.configure_apipie" do |app|
      Apipie.configure do |config|
        config.api_controllers_matcher = [
          "#{Iqvoc::Engine.root}/app/controllers/*.rb",
          "#{Iqvoc::Engine.root}/app/controllers/concepts/*.rb"
        ]
      end

      Apipie.class_eval do
        def self.recorded_examples
          YAML.load_file(Iqvoc.root.join('doc', 'apipie_examples.yml'))
        end
      end
    end
  end

end
