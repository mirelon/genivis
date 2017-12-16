class CreateNodes < ActiveRecord::Migration[5.0]
  def change
    create_table :nodes do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.boolean :is_alive
      t.integer :birthyear
      t.integer :birthmonth
      t.integer :birthday
      t.string :geni_id, index: true

      t.timestamps
    end
  end
end
