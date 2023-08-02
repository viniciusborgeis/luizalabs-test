class CreateResults < ActiveRecord::Migration[7.0]
  def change
    create_table :results do |t|
      t.float :value
      t.references :user, null: false, foreign_key: true
      t.references :competition, null: false, foreign_key: true

      t.timestamps
    end
  end
end
