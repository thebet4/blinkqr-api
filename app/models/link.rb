class Link < ApplicationRecord
  has_many :analytics
  belongs_to :user, optional: true

  before_validation :set_code, on: :create
  before_validation :set_expire_date, on: :create
  before_validation :set_total_access, on: :create

  validates :origin, presence: true
  validates :code, presence: true, uniqueness: true
  validates :expire_date, presence: true
  validates :total_access, presence: true

  def set_code
    self.code = SecureRandom.hex(6)
  end

  def set_expire_date
    self.expire_date = 2.days.from_now if self.expire_date.blank?
  end

  def set_total_access
    self.total_access = 0
  end
end
