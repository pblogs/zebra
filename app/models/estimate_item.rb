class EstimateItem < ActiveRecord::Base
  belongs_to :job_estimate

  validates :title, :quantity, :price, presence: true

  before_save :strip_title

  def strip_title
    self.title = self.title.strip
  end
end
