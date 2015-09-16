class PhoneNumber < ActiveRecord::Base
  validates :number, uniqueness: true
end
