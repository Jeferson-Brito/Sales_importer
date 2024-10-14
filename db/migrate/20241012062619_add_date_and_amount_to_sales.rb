class AddDateAndAmountToSales < ActiveRecord::Migration[7.2]
  def change
    add_column :sales, :date, :date
    add_column :sales, :amount, :decimal
  end
end
