class Account::UrlsController < AccountController
  before_action :set_url, only: [:show, :edit, :update]

  def index 
    # @favicon_url = fetch_favicon(@url.long_url)
    @urls = current_account.urls.order(created_at: :desc)

    @favicon_urls = {} # Initialize an empty hash to store favicon URLs for each URL
    
    @urls.each do |url|
      if url.long_url.present?
        @favicon_urls[url.id] = fetch_favicon(url.long_url)
        # Handle the case where long_url is not present for a URL
      end
    end
  end

  def new 
    @url = Url.new
    @domain_url = @url.show_domain_url
  end

  def show 
    # Load URL with counter cache
    @url = Url.find_by(short_code: params[:short_code])
    
    # Fetch metadata and favicon asynchronously using Rails cache
    @favicon_url = fetch_favicon(@url.long_url)
    @og_data = fetch_metadata(@url.long_url)
    
    # Get analytics data with caching
    @analytics = Rails.cache.fetch("url_analytics/#{@url.id}", expires_in: 5.minutes) do
      {
        clicks_count: @url.clicks.where(source: nil).count,
        scanned_qr_count: @url.clicks.where(source: "qr").count,
        clicks_last_7_days: @url.clicks.where('created_at >= ?', 7.days.ago).count,
        weekly_change_percentage: calculate_weekly_change_percentage(@url),
        # Combine analytics queries into single ones
        location_stats: @url.clicks.group(:country, :region, :city).count,
        device_stats: @url.clicks.group(:device).count,
        os_stats: @url.clicks.group(:os).count
      }
    end
    
    # Assign variables for view
    @clicks_count = @analytics[:clicks_count]
    @scanned_qr_count = @analytics[:scanned_qr_count]
    @clicks_last_7_days = @analytics[:clicks_last_7_days]
    @weekly_change_percentage = @analytics[:weekly_change_percentage]
    @location_stats = @analytics[:location_stats]
    @device_stats = @analytics[:device_stats]
    @os_stats = @analytics[:os_stats]
  end

  def create
    @url = current_account.urls.new(url_params)
    if @url.save
      redirect_to account_url_path(@url), notice: 'URL was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit 
    @domain_url = @url.show_domain_url
  end

  def update
    if @url.update(url_params)
      redirect_to account_url_path(@url), notice: 'URL was successfully updated.'
    else
      render :edit
    end
  end

  def destroy 
    @url = Url.find_by(short_code: params[:short_code])
    if @url.present?
      @url.destroy
      redirect_to account_urls_url, notice: 'URL was successfully destroyed.'
    else
      redirect_to account_urls_url, alert: 'URL not found.'
    end
  end

  def fetch_favicon(long_url)
    Rails.cache.fetch("favicon/#{long_url}", expires_in: 1.week) do
      domain = URI.parse(long_url).host
      "https://www.google.com/s2/favicons?domain=#{domain}&sz=40"
    rescue URI::InvalidURIError
      nil
    end
  end

  def fetch_metadata(long_url)
    Rails.cache.fetch("metadata/#{long_url}", expires_in: 1.day) do
      og_data = {}
      begin
        doc = Nokogiri::HTML(URI.open(long_url))
        og_data[:title] = doc.at('meta[property="og:title"]')&.[]('content') || doc.title
        og_data[:description] = doc.at('meta[property="og:description"]')&.[]('content') || doc.at('meta[name="description"]')&.[]('content')
        og_data[:image] = doc.at('meta[property="og:image"]')&.[]('content')
        og_data[:favicon] = doc.at('link[rel="icon"]')&.[]('content') || doc.at('link[rel="shortcut icon"]')&.[]('content')
      rescue => e
        Rails.logger.error("Failed to fetch metadata: #{e.message}")
      end
      og_data
    end
  end

  private

  def set_url
    @url = Url.find_by(short_code: params[:short_code])
  end

  def url_params
    params.require(:url).permit(:long_url, :short_code, :title)
  end

  def calculate_weekly_change_percentage(url)
    Rails.cache.fetch("weekly_change/#{url.id}", expires_in: 1.hour) do
      current_week = url.clicks.where('created_at >= ?', Date.today.beginning_of_week(:sunday)).count
      previous_week = url.clicks.where(
        'created_at >= ? AND created_at < ?',
        2.weeks.ago.beginning_of_week(:sunday),
        1.week.ago.beginning_of_week(:sunday)
      ).count

      if previous_week > 0
        ((current_week - previous_week).to_f / previous_week * 100).round(2)
      else
        current_week > 0 ? 100 : 0
      end
    end
  end
  
end
