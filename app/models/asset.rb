class Asset < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :attachable, polymorphic: true
  has_attached_file :image, styles: {small: '100x100>'}
  validates_attachment_content_type :image, content_type: ['image/jpeg', 'image/png', 'image/gif', 'application/pdf']
end
