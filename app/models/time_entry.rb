class TimeEntry < ActiveRecord::Base
  belongs_to :time_sheet
  belongs_to :user
  has_and_belongs_to_many :jobs

  def hours
    if self.clock_out && self.clock_in && self.time_sheet
      ((self.clock_out - self.clock_in - (self.time_sheet.lunch * 60))/3600)
    elsif self.clock_out && self.clock_in
      ((self.clock_out - self.clock_in)/3600)
    else
      0
    end
  end

  def per_diem
    self.time_sheet.per_diem_percent rescue 0
  end

  def per_diem_cost
    (self.per_diem * self.time_sheet.per_diem_rate) rescue 0
  end

  def straight_time
    self.hours >= 10 ? 10 : self.hours
  end

  def over_time
    self.hours >= 10 ? (self.hours - 10) : 0
  end

  def cost
    (self.straight_time.to_f * self.rate) + (self.over_time.to_f * self.rate * 1.5) + self.per_diem_cost
  end

end
