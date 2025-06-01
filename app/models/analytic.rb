class Analytic < ApplicationRecord
    belongs_to :link

    validates :ip_address, presence: true, allow_blank: true
    validates :user_agent, presence: true, allow_blank: true
    validates :referrer, presence: true, allow_blank: true
    validates :country, presence: true, allow_blank: true
    validates :city, presence: true, allow_blank: true
    validates :device_type, presence: true, allow_blank: true
    validates :os, presence: true, allow_blank: true
    validates :browser, presence: true, allow_blank: true
    validates :browser_version, presence: true, allow_blank: true
    validates :browser_language, presence: true, allow_blank: true
end