class EmailerMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.emailer_mailer.send_email.subject
  #
  def send_email(emailer)
    @to = emailer.email
    @content = emailer.content
    @subject = emailer.subject

    mail( to: @to, subject: @subject )
  end
end
