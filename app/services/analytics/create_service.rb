# app/services/analytics/create_service.rb

module Analytics
    class CreateService
      def initialize(link:, request:)
        @link = link
        @request = request
      end
  
      def call
        geolocation = fetch_geolocation
        device_info = parse_device_info
  
        @link.analytics.create!(
          ip_address: @request.remote_ip,
          user_agent: @request.user_agent,
          referrer: @request.referer,
          browser_language: @request.headers["Accept-Language"],
          device_type: device_info[:device_type],
          os: device_info[:os],
          browser: device_info[:browser],
          browser_version: device_info[:browser_version],
          country: geolocation[:country],
          city: geolocation[:city]
        )
      rescue => e
        Rails.logger.error("Failed to create analytic: #{e.message}")
        nil
      end
  
      private
        def fetch_geolocation
            result = Geocoder.search(@request.remote_ip).first
            {
            country: result&.country,
            city: result&.city
            }
        rescue => e
            Rails.logger.error("Geolocation failed: #{e.message}")
            { country: nil, city: nil }
        end
    
        def parse_device_info
            browser = Browser.new(@request.user_agent)
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
  end
  