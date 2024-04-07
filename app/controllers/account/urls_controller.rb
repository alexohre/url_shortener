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
    @favicon_url = fetch_favicon(@url.long_url)
    # counting clicks
    @clicks_count = @url.clicks.count
    # conting clicks for last 7 days
    @clicks_last_7_days = @url.clicks.where('created_at >= ?', 7.days.ago).count

    # calculating weekly change percentage
    @weekly_change_percentage = calculate_weekly_change_percentage(@url)

    # scanned count
    @scanned_qr_count = @url.clicks.where(source: "qr").count
    @clicks_count = @url.clicks.where(source: nil).count
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
    domain = URI.parse(long_url).host
    "https://www.google.com/s2/favicons?domain=#{domain}&sz=40"
  rescue URI::InvalidURIError
    nil
  end

  private

  def set_url
    @url = Url.find_by(short_code: params[:short_code])
  end


  def url_params
    params.require(:url).permit(:long_url, :short_code, :title)
  end

  def calculate_weekly_change_percentage(url)
    current_week_clicks = url.clicks.where('created_at >= ?', Date.today.beginning_of_week(:sunday)).count

    if Date.today.beginning_of_week(:sunday) > 0.weeks.ago
      # Current date is within the first week, so there's no previous week
      return 0
    else
      previous_week_clicks = url.clicks.where('created_at >= ? AND created_at < ?', 2.weeks.ago.beginning_of_week(:sunday), 1.week.ago.beginning_of_week(:sunday)).count
      if previous_week_clicks > 0
        return ((current_week_clicks - previous_week_clicks).to_f / previous_week_clicks) * 100
      else
        return current_week_clicks > 0 ? 100 : 0
      end
    end
  end
  
end
