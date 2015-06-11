class Client < ActiveRecord::Base

  has_many :jobs
  has_many :client_contacts, :dependent => :destroy

  validates_presence_of :name
  validates_uniqueness_of :name

  def full_address
    return [self.address, self.city, self.province, self.postal_code].reject(&:blank?).join(', ')
  end
end
