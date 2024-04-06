# app/controllers/title_fetcher_controller.rb
class TitleFetcherController < ApplicationController
  require 'open-uri'
  require 'nokogiri'

  def fetch_title
    url = params[:url]
    title = fetch_title_from_url(url)
    render json: { title: title }
  end

  private

  def fetch_title_from_url(url)
    begin
      html = URI.open(url)
      doc = Nokogiri::HTML(html)
      doc.title
    rescue StandardError => e
      Rails.logger.error("Error fetching title: #{e.message}")
      nil
    end
  end
end
