class Event < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :eventable, polymorphic: true
  belongs_to :crew
end
