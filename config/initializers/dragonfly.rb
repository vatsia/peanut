require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "e247a69a34a720994d60b43ddf494d2e36b05247c843934a370bfd4d16479f7f"

  url_format "/media/:job/:name"

  #datastore :file,
  #  root_path: Rails.root.join('public/system/dragonfly', Rails.env),
  #  server_root: Rails.root.join('public')

  datastore :file,
      root_path: Rails.root.join('public/system/dragonfly', Rails.env),
      server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
