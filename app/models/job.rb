class Job < ActiveRecord::Base

  versioned

  has_and_belongs_to_many :crews
  belongs_to :client
  belongs_to :completion
  has_many :load_sheets
  has_many :gun_sheets
  has_many :gun_markings, :through => :gun_sheets
  has_many :job_sheets
  has_many :job_markings
  has_many :job_locations
  has_many :estimates
  has_many :material_reports
  has_many :time_sheets, :through => :estimates
  has_and_belongs_to_many :time_entries
  accepts_nested_attributes_for :time_sheets, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :job_markings, :reject_if => lambda { |a| a[:gun_marking_category_id].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :job_locations, :reject_if => lambda { |a| a[:name].blank? },  :allow_destroy => true

  # Is active or not
  scope :active, -> { where(:is_archived => false) }

  # This is a static method that all the sheets refer to
  # created to make the Job#show report have an archived date
  def self.archive_date
    Time.parse("January 31 23:59:59 #{Time.now.year}")
  end

  def label
    label = '#' + self.id.to_s
    label += ", " + self.name if self.name
    label
  end

  # Sums of gun sheet properties
  def total_interchanges
    gun_sheets.collect{|gs| if gs.interchanges.blank? then 0 else gs.interchanges end}.sum
  end

  def total_sides
    gun_sheets.collect{|gs| if gs.sides.blank? then 0 else gs.sides end}.sum
  end

  def summary_white_length
    gun_sheets.collect(&:white_length).sum
  end

  def summary_yellow_length
    gun_sheets.collect(&:yellow_length).sum
  end

  def summary_bead_length
    summary_white_length + summary_yellow_length
  end

  def solid_y1_sum
    gun_sheets.collect(&:solid_y1).sum
  end

  def solid_y2_sum
    gun_sheets.collect(&:solid_y2).sum
  end

  def solid_y3_sum
    gun_sheets.collect(&:solid_y3).sum
  end

  def solid_w4_sum
    gun_sheets.collect(&:solid_w4).sum
  end

  def solid_w5_sum
    gun_sheets.collect(&:solid_w5).sum
  end

  def solid_w6_sum
    gun_sheets.collect(&:solid_w6).sum
  end

  def solid_w7_sum
    gun_sheets.collect(&:solid_w7).sum
  end

  def skip_y1_sum
    gun_sheets.collect(&:skip_y1).sum
  end

  def skip_y2_sum
    gun_sheets.collect(&:skip_y2).sum
  end

  def skip_y3_sum
    gun_sheets.collect(&:skip_y3).sum
  end

  def skip_w4_sum
    gun_sheets.collect(&:skip_w4).sum
  end

  def skip_w5_sum
    gun_sheets.collect(&:skip_w5).sum
  end

  def skip_w6_sum
    gun_sheets.collect(&:skip_w6).sum
  end

  def skip_w7_sum
    gun_sheets.collect(&:skip_w7).sum
  end

  # Report Summaries Properties
  def num_job_markings
    job_markings.collect().count
  end

  def total_job_value
    job_markings.collect{|m| m.total_value}.sum rescue 0
  end

  def location_label
    sub_locations = self.job_locations.map(&:name).join(", ")

    sub_locations.empty? ? self.location_name : self.location_name + ", " + sub_locations
  end

  # This function is used to translate the Color (State) variables, as set in
  #  views/private/_form.html.erb
  #  ["", "Red (deficiencies)", "Green (ready)", "Orange (scheduled)", "Blue (in progress)", "White (complete)"]
  # to CSS friendly ones, as displayed in
  #  views/private/jobs/_display.html.erb
  # <tr class="<% job.get_completion_color_class_name %>">

  def get_completion_color_class_name
    return self.completion_color if self.completion_color.blank?

    self.completion_color.split[0].downcase
  end

end
