class User < ActiveRecord::Base
  acts_as_authentic

  belongs_to :crew
  has_many :time_entries
  has_and_belongs_to_many :roles

  has_one :daily_report # This object, if exists, means the User is going through the Clock Out process.

  has_many :gun_sheets, :foreign_key => "created_by"

  validates_presence_of :first_name, :last_name, :rate, :employment_start_date
  validates :bank_overtime_hours, :inclusion => {:in => [true, false]}

  validates :roles, :length => { :minimum => 1, :message => 'Please select at least 1 role'}

  has_many :comments

  # attr_accessible :login, :password, :password_confirmation, :email, :first_name, :last_name,:role_ids, :time_zone

  #for declarative authorization
  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    SiteMailer.password_reset_instructions(self).deliver
  end

  def name
    self.first_name + " " + self.last_name
  end

  def role_list
    list = Array.new
    roles.each do |role|
      list << role.name
    end
    list.join(", ")
  end

end

