class AddDipsToMaterialReports < ActiveRecord::Migration

  def self.up
    add_column :material_reports, :yellow_dip_start, :decimal, default: 0
    add_column :material_reports, :yellow_dip_end, :decimal, default: 0
    add_column :material_reports, :white_dip_start, :decimal, default: 0
    add_column :material_reports, :white_dip_end, :decimal, default: 0

    LoadSheet.all.each do |ls|
      MaterialReport.where(load_sheet_id: ls.id).each do |m|
        m.update_attributes(yellow_dip_start: ls.adjusted_yellow_dip_start, yellow_dip_end: ls.adjusted_yellow_dip_end,
                            white_dip_start: ls.adjusted_white_dip_start, white_dip_end: ls.adjusted_white_dip_end)
      end
    end
  end

  def self.down
    remove_column :material_reports, :yellow_dip_start
    remove_column :material_reports, :yellow_dip_end
    remove_column :material_reports, :white_dip_start
    remove_column :material_reports, :white_dip_end
  end
end
