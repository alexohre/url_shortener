# app/controllers/subscriptions_controller.rb
class Account::SubscriptionsController < AccountController
  # before_action :set_account

  def update
    # Fetch the new plan from the parameters
    new_plan = subscription_params[:plan]
    new_billing_cycle = subscription_params[:billing_cycle] || 'monthly'

    # Calculate the new expiration date based on the plan and billing cycle
    new_expiry = Time.now + Subscription::BILLING_CYCLES[new_billing_cycle.to_sym]

    @account = current_account
    # Update the subscription
    if @account.subscription.update(plan: new_plan, billing_cycle: new_billing_cycle, active_until: new_expiry)
      @account.subscription.update(trial_ends_at: nil) if new_plan != 'standard'
      flash[:notice] = "Subscription updated to #{new_plan.capitalize}."
      redirect_to account_dashboard_subscription_path
    else
      flash[:alert] = "Failed to update the subscription."
      redirect_to account_dashboard_subscription_path
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:plan, :billing_cycle, :active_until)
  end
end
