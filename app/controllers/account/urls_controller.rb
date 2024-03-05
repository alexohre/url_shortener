class Account::UrlsController < AccountController

  def index 
    @urls = current_account.urls.order(created_at: :desc)
  end

  def new 
    @url = Url.new
  end

  def show 
    @url = Url.includes(:clicks).find(params[:id])
    # counting clicks
    @clicks_count = @url.clicks.count
    # conting clicks for last 7 days
    @clicks_last_7_days = @url.clicks.where('created_at >= ?', 7.days.ago).count

    # calculating weekly change percentage
    @weekly_change_percentage = calculate_weekly_change_percentage(@url)

    # scanned count
    @scanned_qr_count = Click.where(source: "qr").count
  end

  def create
    @url = current_account.urls.new(url_params)
    if @url.save
      redirect_to account_urls_path, notice: 'URL was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

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
