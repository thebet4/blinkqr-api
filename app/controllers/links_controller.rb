class LinksController < ApplicationController
  before_action :set_link, only: %i[ update destroy ]
  before_action :set_link_by_code, only: %i[ show ]
  before_action :authorize, only: %i[ index update destroy ]
  before_action :validate_user_link, only: %i[ update destroy ]

  def index
    @links = current_user.links
    render json: @links, status: :ok
  end

  def show
    if @link.expire_date < Date.today
      render json: { error: "Link expired" }, status: :gone
      return
    end
  
    @link.increment!(:total_access)
  
    Analytics::CreateService.new(link: @link, request: request).call
  
    render json: { origin: @link.origin }, status: :ok
  end

  # POST /links
  def create
    @link = Link.new(link_params)

    if current_user
      @link.user = current_user
    end

    if @link.save
      render json: @link, status: :created, location: @link
    else
      render json: @link.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /links/1
  def update
    if @link.update(link_params)
      render json: @link
    else
      render json: @link.errors, status: :unprocessable_entity
    end
  end

  # DELETE /links/1
  def destroy
    if @link.destroy!
      render json: { message: "Link deleted" }, status: :ok
    else
      render json: { error: "Failed to delete link" }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      begin
        @link = Link.find(params.expect(:id))
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Link not found" }, status: :not_found
      end
    end

    def set_link_by_code
      begin
        @link = Link.find_by(code: params.expect(:id))
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Link not found" }, status: :not_found
      end
    end

    def validate_user_link
      if @link.user_id != @user.id
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end

    # Only allow a list of trusted parameters through.
    def link_params
      params.expect(link: [ :origin, :expire_date ])
    end

    def fetch_geolocation(ip)
      result = Geocoder.search(ip).first
      {
        country: result&.country,
        city: result&.city
      }
      rescue => e
        Rails.logger.error("Geolocation failed: #{e.message}")
        { country: nil, city: nil }
    end

    def parse_device_info(user_agent)
      browser = Browser.new(user_agent)
      device_type = if browser.device.mobile?
                      'mobile'
                    elsif browser.device.tablet?
                      'tablet'
                    else
                      'desktop'
                    end
    
      {
        device_type: device_type,
        os: browser.platform.name,
        browser: browser.name,
        browser_version: browser.full_version
      }
    end
end
