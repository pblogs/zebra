class Equipment < ActiveRecord::Base

  has_and_belongs_to_many :crews
  has_many :load_sheets
  has_many :gun_sheets
  has_many :assets, as: :attachable

  accepts_nested_attributes_for :assets

  validates_presence_of :unit
  validates_presence_of :name
  validates_presence_of :rate

  scope :unassigned, -> { where('crews_equipment.crew_id IS NULL').includes(:crews).order('unit ASC') }

  COLORS = ['green', 'blue', 'yellow', 'purple']

  class << self
    def check_for_black_and_red_flags
      puts "Checking #{Equipment.count} equipment units"
      Equipment.all.each do |equipment|
        equipment.check_flags
      end
    end
  end

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

  def red_flag?
    return false if self.registration_date.blank?
    return Date.today > self.registration_date + 11.months
  end

  def black_flag?
    return false if self.cvip_date.blank?
    return Date.today > self.cvip_date + 11.months
  end

  def should_send_red_flag_alert?
    return ( red_flag? and red_flag_alert_sent_at.blank? and Date.today > self.registration_date + (1.year - 1.week) )
  end

  def should_send_black_flag_alert?
    return ( black_flag? and black_flag_alert_sent_at.blank? and Date.today > self.cvip_date + (1.year - 2.week) )
  end

  def check_flags
    puts "-- checking #{self.name}"
    if should_send_red_flag_alert?
      puts "---- sending Red Flag Alert"
      SiteMailer.equipment_alert(self, 'red_flag').deliver
      self.red_flag_alert_sent_at = Time.zone.now
      self.save
    end

    if should_send_black_flag_alert?
      puts "---- sending Black Flag Alert"
      SiteMailer.equipment_alert(self, 'black_flag').deliver
      self.black_flag_alert_sent_at = Time.zone.now
      self.save
    end
  end

end
