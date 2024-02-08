class Admin::CurrencyPairsController < ApplicationController
  require 'csv'

  def create
    @currency_pair = CurrencyPair.new(currency_pair_params)
    if @currency_pair.save
      redirect_to admin_settings_currency_pairs_path, notice: 'Currency pair was successfully created.'
    else
      redirect_to admin_settings_currency_pairs_path, alert: 'Currency pair was successfully created.'
    end
  end

  def destroy
    @currency_pair = CurrencyPair.find(params[:id])
    @currency_pair.destroy
    redirect_to admin_settings_currency_pairs_path, notice: 'Currency pair was successfully deleted.'
  end

  def import_csv
    csv_file = params[:file]
    CSV.foreach(csv_file.path, headers: true) do |row|
      currency_pair_params = {
        base_currency: row['Base Currency'].upcase,
        quote_currency: row['Quote Currency'].upcase
      }
      CurrencyPair.create(currency_pair_params)
    end
    redirect_to admin_settings_currency_pairs_path, notice: 'Currency pairs were successfully imported from CSV.'
  end

  private

  def currency_pair_params
    params.require(:currency_pair).permit(:base_currency, :quote_currency)
  end
end