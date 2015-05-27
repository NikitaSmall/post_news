PostNews::Application.configure do
  PAPERCLIP_STORAGE_OPTIONS = {
      :styles => { :medium => "500x500>", :thumb => "100x100>" },
      :url  => ":s3_domain_url",
      :path => "public/photos/:id/:style_:basename.:extension",
      :storage => :fog,
      :fog_credentials => {
          provider: 'AWS',
          aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
          aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
      },
      fog_directory: ENV["FOG_DIRECTORY"]
  }

  PAPERCLIP_STORAGE_ADV_OPTIONS = {
      :styles => { :medium => "500x500>", :thumb => "100x100>" },
      :url  => ":s3_domain_url",
      :path => "public/adv/:id/:style_:basename.:extension",
      :storage => :fog,
      :fog_credentials => {
          provider: 'AWS',
          aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
          aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
      },
      fog_directory: ENV["FOG_DIRECTORY"]
  }

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  config.assets.cache_store = :null_store  # Disables the Asset cache
  config.sass.cache = false  # Disable the SASS compiler cache
end
