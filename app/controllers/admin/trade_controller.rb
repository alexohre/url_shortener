class Admin::TradeController < AdminController
  def active
    @title = "Active Trade"
  end

  def inactive
    @title = "Inactive Trade"
  end
end