class RemoveProfessionalIdFromServices < ActiveRecord::Migration[7.1]
  def change
    remove_column :services, :professional_id, :integer
  end
end
