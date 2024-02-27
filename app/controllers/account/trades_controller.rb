class Account::TradesController < AccountController
  before_action :check_profile_completion

  def new_trade
    @title = "Place a trade"
    @trade = Trade.new
    @currency_pairs = CurrencyPair.all
  end

  def trade_history
    @title = "Trade histories"
    @trades = current_account.trades.includes(:currency_pair).order(id: :desc)
    @pagy, @trades = pagy(current_account.trades.includes(:currency_pair).order(id: :desc), items: 8)
  end

  def create
    @trade = Trade.new(trade_params)
    if @trade.amount <= current_account.balance
      @trade.account = current_account
      @trade.trade_type = params[:trade_type]# == 'sell' ? 'sell' : 'buy'
      @trade.status = "running" # Set the initial status to "Running"
      @trade.order_id = SecureRandom.hex(5)
      if @trade.save
        current_account.update(balance: current_account.balance - @trade.amount, trade: current_account.trade += 1)
        if @trade.time_duration.present?
          duration_in_minutes = extract_duration_in_minutes(@trade.time_duration)
          job = TradeJob.set(wait_until: @trade.created_at + duration_in_minutes.minutes).perform_later(@trade.id)
          @trade.update(job_id: job.job_id) # Save the job_id to the trade record
        end
        redirect_to account_trades_trade_history_path, notice: 'Trade was successfully created.'
      else
        # redirect_to account_trades_new_trade_path, alert: 'Oops, Something went wrong please try again'
        @currency_pairs = CurrencyPair.all
        render :new_trade, status: :unprocessable_entity
      end
    else
      redirect_to account_trades_new_trade_path, alert: 'Trade amount exceeds your account balance.'
    end
  end

  # to be completed later
  def cancel
    @trade = Trade.find(params[:id])

    if @trade.completed?
      redirect_to account_trades_trade_history_path, alert: 'Cannot cancel a completed trade.'
    else
      if @trade.running?
        # Retrieve the job ID from the trade record
        job_id = @trade.job_id

        if job_id.present?
          # Find the enqueued job by its ID and destroy it
          # begin
            # job = AsyncJob::TradeJob.find_by(job_id: job_id)
            Sidekiq::Queue.new("default").find_job(job_id).delete

          # rescue Sidekiq::JobNotFound
            # Handle the case where the job no longer exists
            # Rails.logger.warn("Job with ID #{job_id} not found.")
          # end
        end

        # Update the trade status and profit_loss
        @trade.update(status: :cancelled, profit_loss: 0)
        redirect_to account_trades_trade_history_path, notice: 'Trade was successfully cancelled.'
      else
        redirect_to account_trades_trade_history_path, alert: 'Cannot cancel a trade that is not running.'
      end
    end
  end

  private

  def trade_params
    params.require(:trade).permit(:currency_pair_id, :amount, :time_duration, :trade_type, :status, :account_type, :account_id)
  end

  def check_profile_completion
    if current_account && (current_account.first_name.blank? || current_account.last_name.blank? || current_account.address.blank? || current_account.state.blank? || current_account.country.blank?)
      redirect_to edit_account_registration_path, alert: "Please complete your profile information."
    end
  end

  def extract_duration_in_minutes(time_duration)
    # Extract the numeric value from the time duration string and convert it to minutes
    time_duration.scan(/\d+/).first.to_i
  end
end