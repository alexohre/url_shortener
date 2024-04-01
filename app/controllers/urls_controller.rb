class UrlsController < ApplicationController
  require 'net/http'
  require 'json'

  def redirect
    # Find the URL record based on the short code
    url = Url.find_by(short_code: params[:short_code])
    #  check if the url is present
    if url
      # Track additional information
      source = params[:s]
       if source == "qr" || source.blank?
        user_agent_string = request.user_agent
        ip_address = request.remote_ip

        # Parse user agent string to extract browser and device information
        user_agent = UserAgent.parse(user_agent_string)
        browser = user_agent.browser
        device = infer_device(user_agent_string)

        # Retrieve user's city and country from IP address
        city, region, country, timezone = retrieve_location_from_ip(ip_address)

        # Increment click count
        url.increment!(:click_count)

        # Save additional information to the database
        Click.create!(
          url_id: url.id,
          source: source,
          user_agent: user_agent_string,
          ip_address: ip_address,
          city: city,
          region: region,
          country: country,
          timezone: timezone,
          browser: browser,
          device: device
        )
        
        redirect_to url.long_url, allow_other_host: true

       else
        render plain: "Invalid source parameter", status: :bad_request
       end
    else
      # Handle invalid or expired URL
      render plain: "Invalid or expired URL", status: :not_found
    end
  end

  private

  def retrieve_location_from_ip(ip_address)
    if Rails.env.development?
    # If in development environment, return a default region
      return ['Local City', 'Local Region', 'Local Country', 'Local Timezone']
    else
      # Send a request to the geolocation API to retrieve the user's location based on their IP address
      response = Net::HTTP.get_response(URI("https://ipinfo.io/#{ip_address}/json"))

      # Parse the JSON response
      data = JSON.parse(response.body)

      # Extract the city and country from the response
      city = data['city']
      region = data['region']
      country = data['country']
      timezone = data['timezone']

      [city, region, country, timezone] # Return city and country as an array
    end
  end

  def infer_device(user_agent_string)
    # Infer device type based on keywords in the user agent string
    if user_agent_string.downcase.include?('mobile')
      'Mobile'
    elsif user_agent_string.downcase.include?('tablet')
      'Tablet'
    else
      'Desktop'
    end
  end

  def infer_os(user_agent_string)
    # Infer OS based on keywords in the user agent string
    if user_agent_string.downcase.include?('windows')
      'Windows'
    elsif user_agent_string.downcase.include?('macintosh') || user_agent_string.downcase.include?('mac os')
      'Mac OS'
    elsif user_agent_string.downcase.include?('linux')
      'Linux'
    elsif user_agent_string.downcase.include?('iphone')
      'iOS'
    elsif user_agent_string.downcase.include?('android')
      'Android'
    else
      'Unknown'
    end
  end

  
  
end
