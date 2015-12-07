class UpdateAllGunMarkingCategories < ActiveRecord::Migration
  def up
    GunMarkingCategory.all.map{|g| g.update_attributes(name: g.name.strip)}
  end

  def down
  end
end
