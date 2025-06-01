class CreateLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :links do |t|
      t.string :code
      t.string :origin
      t.date :expire_date
      t.integer :total_access

      t.timestamps
    end
  end
end
