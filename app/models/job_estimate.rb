class JobEstimate < ActiveRecord::Base
  has_many :estimate_items
  has_many :assets, as: :attachable
  accepts_nested_attributes_for :estimate_items, allow_destroy: true
  accepts_nested_attributes_for :assets

  STATE = {
    1 => 'Draft',
    2 => 'Accepted',
    3 => 'Declined',
    4 => 'Sent'
  }
end
