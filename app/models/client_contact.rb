class ClientContact < ActiveRecord::Base
  belongs_to :client
  validates_presence_of :client_id, :name

end
