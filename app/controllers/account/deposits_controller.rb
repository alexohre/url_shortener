class Account::DepositsController < AccountController
  before_action :check_profile_completion

  def deposit
    @title = "Deposit funds to your account"
    @payment_methods = PaymentMethod.includes(wallet_qrcode_attachment: :blob)
    @deposit = Deposit.new
  end

  def deposit_history
    @title = "Deposit History"
    @pagy, @deposits = pagy(current_account.deposits.includes(:account, :payment_method, payment_proof_attachment: :blob).order(id: :desc), items: 8)
  end

  def create
    @deposit = Deposit.new(deposit_params.except(:wallet_address))
    @deposit.account = current_account
    @deposit.status = "pending" # Set the initial status to "Running"
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

  def check_profile_completion
    if current_account && (current_account.first_name.blank? || current_account.last_name.blank? || current_account.address.blank? || current_account.state.blank? || current_account.country.blank?)
      redirect_to edit_account_registration_path, alert: "Please complete your profile information."
    end
  end
end