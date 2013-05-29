class Equipment < ActiveRecord::Base

  has_and_belongs_to_many :crews
  has_many :load_sheets
  has_many :gun_sheets
  validates_presence_of :unit
  validates_presence_of :name
  validates_presence_of :rate

  scope :unassigned, -> { where('crews_equipment.crew_id IS NULL').includes(:crews).order('unit ASC') }

  def cost(job_sheet)
    if self.rate
      @job_sheet = JobSheet.find(job_sheet)
      @job_sheet.time_sheets.length * self.rate
    else
      0
    end
  end

  def label
    self.unit + " " + self.name
  end

end
