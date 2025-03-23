class Subscription < ApplicationRecord
  belongs_to :account

  PLANS = {
    'free' => { monthly: 0, yearly: 0 },
    'standard' => { monthly: 500, yearly: 6000 }, 
    'premium' => { monthly: 1000, yearly: 12000 } 
  }.freeze

  
  validates :plan, inclusion: { in: PLANS.keys }
  
  after_initialize :set_default_plan, if: :new_record?
  
  before_save :end_trial_if_upgrading

  BILLING_CYCLES = { monthly: 1.month, yearly: 1.year }

  def set_default_plan
    self.plan ||= 'standard'
    self.trial_ends_at ||= 7.days.from_now if self.plan == 'standard'
    self.billing_cycle ||= 'monthly'
  end

  def end_trial_if_upgrading
    if plan_changed? && !new_record?
      self.trial_ends_at = nil if plan_was == 'standard' && plan != 'standard'
    end
  end

  def paid_plan?
    %w[standard premium].include?(plan) && (trial_ends_at.nil? || trial_ends_at > Time.current)
  end

  def revert_to_free_plan
    update(plan: 'free', trial_ends_at: nil) if trial_ends_at.present? && trial_ends_at < Time.current
  end

  def yearly?
    billing_cycle == 'yearly'
  end

  def monthly?
    billing_cycle == 'monthly'
  end

  def monthly_price
    PLANS[plan][:monthly]
  end

  def yearly_price
    PLANS[plan][:yearly]
  end
end
