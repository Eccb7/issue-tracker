# Configure Turbo for proper handling of DELETE requests
Rails.application.config.to_prepare do
  # Enable turbo for DELETE requests
  Turbo::Engine.config.respond_to?(:navigational_formats=) &&
    Turbo::Engine.config.navigational_formats.append(:turbo_stream)
end
