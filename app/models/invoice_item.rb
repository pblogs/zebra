class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice

  validates :title, :quantity, :price, presence: true

  before_save :strip_title

  def strip_title
    self.title = self.title.strip
  end
end
