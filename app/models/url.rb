class Url < ApplicationRecord
  before_create :generate_unique_code, unless: -> { short_code.present? }
  after_create :generate_qr_codes
  before_save :set_default_click_count
  before_save :regenerate_qr_codes_if_short_code_changed

  validates :long_url, presence: true, format: { with: URI.regexp }
  validates :short_code, uniqueness: true

  belongs_to :account
  has_many :clicks, dependent: :destroy
  has_one_attached :qr_code, dependent: :destroy
  has_one_attached :qr_code_png, dependent: :destroy
  has_one_attached :qr_code_jpg, dependent: :destroy

  def generate_qr_codes
    generate_qr_code_svg
    generate_qr_code_png
    # generate_qr_code_jpg
  rescue => e
    Rails.logger.error "Error generating QR codes: #{e.message}"
  end
  
  def domain_url
    Rails.env.production? ? 'https://url.softalx.com' : 'http://localhost:3000'
  end

  # before_validation :generate_unique_code, unless: -> { short_code.present? }
  private

  def set_default_click_count
    self.click_count ||= 0
  end

  def regenerate_qr_codes_if_short_code_changed
    if short_code_changed?
      update_short_url
      generate_qr_codes
    end
  end
  
  def generate_unique_code
    length = SecureRandom.random_number(4) + 5
    self.short_code = SecureRandom.base58(length)
    self.short_url = "#{domain_url}/#{short_code}"
  end

  def update_short_url
    self.short_url = "#{domain_url}/#{short_code}"
  end

  def generate_qr_code_svg
    # Add ?s=qr to the short code
    qr_code_short_code = "#{short_url}?s=qr"

    qr_code = RQRCode::QRCode.new(qr_code_short_code)

    # Generate the SVG data
    svg = qr_code.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 4,
      standalone: true,
      use_path: true,
      width: 160,
      height: 160
    )

        # Create a temporary file to store the SVG data
    temp_svg_file = Tempfile.new(['qr_code', '.svg'])
    temp_svg_file.write(svg)
    temp_svg_file.close

    # Attach the SVG file to the URL model
    self.qr_code.attach(io: File.open(temp_svg_file.path), filename: "#{short_code}.svg")

    # Clean up the temporary file
    temp_svg_file.unlink
  end

  def generate_qr_code_png
    # Generate the PNG data
    # Add ?s=qr to the short code
    qr_code_short_code = "#{short_url}?s=qr"

    qr_code = RQRCode::QRCode.new(qr_code_short_code)

    png = qr_code.as_png(
      bit_depth: 1,
      resize_gte_to: false,
      resize_exactly_to: 160,
      fill: 'white',              # Background color
      color: 'black',             # Color of the QR code modules (dots)
      size: 160,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      border_modules: 1,
      module_px_size: 2,
      file: nil  # Don't write the PNG to a file
    )

    # Load logo image
    # logo_path = ActionController::Base.helpers.asset_path('logo.png')
    # logo = ChunkyPNG::Image.from_file(logo_path)

    # # Calculate the position to center the logo
    # logo_size = 40  # Adjust as needed
    # x_offset = (png.width - logo_size) / 2
    # y_offset = (png.height - logo_size) / 2

    # # Overlay logo onto the QR code
    # png.compose!(logo.resize(logo_size, logo_size), x_offset, y_offset)

    # Convert the PNG data to binary format
    png_binary = png.to_s

    # Attach the PNG data to the URL model
    self.qr_code_png.attach(io: StringIO.new(png_binary), filename: "#{short_code}.png")

    # Clean up any temporary files (if created)
    temp_svg_file.unlink if defined?(temp_svg_file) && temp_svg_file

  end

  # def generate_qr_code_jpg
  #   # Generate the PNG data
  #   # Add ?s=qr to the short code
  #   qr_code_short_code = "#{short_url}?s=qr"

  # qr_code = RQRCode::QRCode.new(qr_code_short_code)

  # png = qr_code.as_png(
  #   resize_gte_to: false,
  #   resize_exactly_to: 160,
  #   fill: 'white',              # Background color
  #   color: 'black',             # Color of the QR code modules (dots)
  #   size: 160,
  #   border_modules: 4,
  #   module_px_size: 6,
  #   file: nil  # Don't write the PNG to a file
  # )

  # # Convert the PNG data to binary format
  # png_binary = png.to_s

  # # Convert PNG binary data to JPG format using MiniMagick
  # image = MiniMagick::Image.read(png_binary) do |b|
  #   b.format "jpg"
  # end

  # # Get the binary data of the JPG image
  # jpg_binary = image.to_blob

  # # Attach the JPG data to the URL model
  # self.qr_code_jpg.attach(io: StringIO.new(jpg_binary), filename: "#{short_code}.jpg")

  # # Clean up any temporary files (if created)
  # temp_svg_file.unlink if defined?(temp_svg_file) && temp_svg_file

  # end

end
