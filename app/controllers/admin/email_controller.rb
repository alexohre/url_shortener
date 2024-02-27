class Admin::EmailController < AdminController
  def sent
    @title = "Sent mails"
    @pagy, @mails = pagy(Emailer.all.order(id: :desc), items: 6)
  end
  
  def new
    @title = "New email"
    @accounts = Account.all.map { |account| [ "#{account.email} - #{account.first_name + ' ' + account.last_name}", account.email ] }
    @emailer = Emailer.new
  end

  def create
    @emailer = Emailer.new(emailer_params)
    if @emailer.save
      # Call the mailer method to send the email
      EmailerMailer.send_email(@emailer).deliver_later
      redirect_to admin_emails_path, notice: 'Email Sent Successfully!.'
    else
      @accounts = Account.all.map { |account| [ "#{account.email} - #{account.first_name + ' ' + account.last_name}", account.email ] }
      render :new, status: :unprocessable_entity
    end
  end

  private

  def emailer_params
    params.require(:emailer).permit(:content, :email, :subject)
  end
end