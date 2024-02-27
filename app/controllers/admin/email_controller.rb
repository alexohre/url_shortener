class Admin::EmailController < AdminController
  def sent
    @title = "Sent mails"
    # @pagy, @mails = pagy(Emailer.all.order(id: :desc), items: 6)
    @pagy, @mails = pagy(Emailer.with_rich_text_content.order(id: :desc), items: 6)
  end
  
  def new
    @title = "New email"
    @accounts = Account.all.map do |account|
        full_name = [account.first_name, account.last_name].compact.join(' ')
        name_to_display = full_name.present? ? full_name : "Awaiting names"
        ["#{account.email} - #{name_to_display}", account.email]
      end
    @emailer = Emailer.new
  end

  def create
    @emailer = Emailer.new(emailer_params)
    if @emailer.save
      # Call the mailer method to send the email
      EmailerMailer.send_email(@emailer).deliver_later
      redirect_to admin_emails_path, notice: 'Email Sent Successfully!.'
    else
      @accounts = Account.all.map do |account|
        full_name = [account.first_name, account.last_name].compact.join(' ')
        name_to_display = full_name.present? ? full_name : "Awaiting names"
        ["#{account.email} - #{name_to_display}", account.email]
      end
      render :new, status: :unprocessable_entity
    end
  end

  private

  def emailer_params
    params.require(:emailer).permit(:content, :email, :subject)
  end
end