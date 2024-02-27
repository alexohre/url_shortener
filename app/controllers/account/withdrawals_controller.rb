class Account::WithdrawalsController < AccountController
  before_action :check_profile_completion

  def withdraw
    @title = "Making Withdrawal"
    @withdrawal = Withdrawal.new
  end

  def withdraw_history
    @title = "Withdrawal History"
    @pagy, @withdrawals = pagy(current_account.withdrawals.includes(:account, :payment_method).order(id: :desc), items: 8)
  end

  def create
    @withdrawal = Withdrawal.new(withdrawal_params)
    @withdrawal.account = current_account
    @withdrawal.status = "pending" # Set the initial status to "Running"
    @withdrawal.order_id = SecureRandom.hex(5)

    if current_account.balance >= @withdrawal.amount
      if @withdrawal.save
        # Subtract the withdrawal amount from the account balance
        current_account.update(balance: current_account.balance - @withdrawal.amount)
        current_account.increment!(:withdrawal)
        redirect_to account_withdrawals_withdraw_history_path, notice: "Withdrawal request submitted successfully."
      else
        redirect_to account_withdrawals_withdraw_path, alert: "Oops, Something went wrong. Please try again..."
      end
    else
      redirect_to account_withdrawals_withdraw_path, alert: "Insufficient balance. Please try again with a lower amount."
    end
  end

  private

  def withdrawal_params
    params.require(:withdrawal).permit(:amount, :payment_method_id, :address, :status, :order_id)
  end

  def check_profile_completion
    if current_account && (current_account.first_name.blank? || current_account.last_name.blank? || current_account.address.blank? || current_account.state.blank? || current_account.country.blank?)
      redirect_to edit_account_registration_path, alert: "Please complete your profile information."
    end
  end
end