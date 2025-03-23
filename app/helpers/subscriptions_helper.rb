module SubscriptionsHelper
  def subscription_button_label(current_plan, target_plan)
    case current_plan
    when 'free'
      target_plan == 'free' ? 'Subscribed' : "Upgrade to #{target_plan.capitalize}"
    when 'standard'
      target_plan == 'standard' ? 'Subscribed' : (target_plan == 'free' ? 'Downgrade to Free' : "Upgrade to #{target_plan.capitalize}")
    when 'premium'
      target_plan == 'premium' ? 'Subscribed' : "Downgrade to #{target_plan.capitalize}"
    else
      'Subscribe'
    end
  end
end