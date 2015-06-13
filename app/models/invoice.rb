class Invoice < ActiveRecord::Base
  has_many :invoice_items
  has_many :assets, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :invoice_items, allow_destroy: true
  accepts_nested_attributes_for :assets

  validates_presence_of :customer_name

  before_save :strip_customer_name, :check_status

  STATUS = {
    0 => 'Draft',
    1 => 'Sent',
    2 => 'Overdue'
  }

  def check_status
    return unless due_date.present?
    if self.due_date > Date.today
      self.status = 1
    else
      self.status = 2
    end
  end

  def strip_customer_name
    self.customer_name = customer_name.strip
  end
end
