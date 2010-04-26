class Crew < ActiveRecord::Base

  has_and_belongs_to_many :jobs
  has_many :users

  def label
    label = 'Crew #' + self.id.to_s
    if self.name : label += ", " + self.name end
    label
  end

  def user_list
    list = []
    self.users.each do |user|
      list << "<span class='#{user.role_symbols}'>#{user.first_name} #{user.last_name}</span>"
    end
    list.join(", ")
  end

end