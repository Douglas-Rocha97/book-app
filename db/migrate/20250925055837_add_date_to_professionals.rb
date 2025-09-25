class AddDateToProfessionals < ActiveRecord::Migration[7.1]
  def change
    add_column :professionals, :date, :date
  end
end
