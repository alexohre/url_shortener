# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3000' # Update with your client-side origin

    resource '/fetch_title',
      headers: :any,
      methods: [:get, :post],
      credentials: true
  end
end
