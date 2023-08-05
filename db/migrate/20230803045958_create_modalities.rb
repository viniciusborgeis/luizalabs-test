class CreateModalities < ActiveRecord::Migration[7.0]
  def change
    create_table :modalities do |t|
      t.string :name, null: false
      t.integer :unit, null: false, default: 0

      t.timestamps
    end
  end
end
