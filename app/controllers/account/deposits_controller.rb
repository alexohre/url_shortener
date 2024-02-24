class Account::DepositsController < AccountController
  def deposit
    @title = "Deposit funds to your account"
    @deposit = Deposit.new
  end

  def deposit_history
    @title = "Deposit History"
    @pagy, @deposits = pagy(current_account.deposits.includes(:account, :payment_method).order(id: :desc), items: 8)
  end

  def create
    @deposit = Deposit.new(deposit_params)
    @deposit.account = current_account
    @deposit.status = "Pending" # Set the initial status to "Running"
    @deposit.order_id = SecureRandom.hex(5)

    if @deposit.save
      current_account.increment!(:deposit)
      redirect_to account_deposits_deposit_history_path, notice: 'Deposit created successfully.'
    else
      redirect_to account_deposits_deposit_path, alert: "Oops, Something went wrong"
    end
  end

  private

  def deposit_params
    params.require(:deposit).permit(:amount, :payment_proof, :payment_method_id, :order_id, :account_id)
  end
end