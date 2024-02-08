class Admin::PaymentMethodsController < AdminController

  def create
    @payment_method = PaymentMethod.new(payment_method_params)
    if @payment_method.save
      redirect_to admin_settings_payment_method_path, notice: 'Payment method was successfully created.'
    else
      redirect_to admin_settings_payment_method_path, alert: 'Payment method was successfully created.'
    end
  end

  def destroy
    @payment_method = PaymentMethod.find(params[:id])
    @payment_method.destroy
    redirect_to admin_settings_payment_method_path, notice: 'Payment method was successfully deleted.'
  end

  private

  def payment_method_params
    params.require(:payment_method).permit(:name, :wallet, :wallet_qrcode)
  end
  
end