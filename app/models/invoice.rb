class Invoice < ActiveRecord::Base
  # attr_accessible :amount, :customer_name,
  #       :customer_notes, :due_date, :emails,
  #       :invoice_date, :invoice_number,
  #       :order_number, :status,
  #       :terms_and_cond
  has_many :invoice_items
  has_many :assets, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :invoice_items, allow_destroy: true
  accepts_nested_attributes_for :assets

  validates_presence_of :customer_name

  before_save :strip_customer_name

  def strip_customer_name
    self.customer_name = customer_name.strip
  end

  STATUS = {
    0 => 'Draft'
  }
end
