class LinksController < ApplicationController
  layout "url"
  def redirect
    @title = "Redirecting..."
    @url = Url.find_by(short_code: params[:short_code])
    if @url
      @og_data = fetch_metadata(@url.long_url)
      render :redirect
    else
      render plain: "Invalid or expired URL", status: :not_found
    end
  end

  private

  def fetch_metadata(long_url)
    og_data = {}
    begin
      doc = Nokogiri::HTML(URI.open(long_url))
      og_data[:title] = doc.at('meta[property="og:title"]')&.[]('content') || doc.title
      og_data[:description] = doc.at('meta[property="og:description"]')&.[]('content') || doc.at('meta[name="description"]')&.[]('content')
      og_data[:image] = doc.at('meta[property="og:image"]')&.[]('content')
      og_data[:favicon] = doc.at('link[rel="icon"]')&.[]('href') || doc.at('link[rel="shortcut icon"]')&.[]('href')
    rescue => e
      Rails.logger.error("Failed to fetch metadata: #{e.message}")
    end
    og_data
  end
end
