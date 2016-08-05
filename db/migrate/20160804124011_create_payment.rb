class CreatePayment < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.string :payment_id
      t.references :order, foreign_key: true
      t.float :total
      t.boolean :complited, default: false
    end
  end
end
