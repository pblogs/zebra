class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.attachment :image
      t.references :attachable, polymorphic: true
      t.timestamps
    end
  end
end
