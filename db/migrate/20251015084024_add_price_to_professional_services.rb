class AddPriceToProfessionalServices < ActiveRecord::Migration[7.1]
  def change
    add_column :professional_services, :price, :integer
  end
end
