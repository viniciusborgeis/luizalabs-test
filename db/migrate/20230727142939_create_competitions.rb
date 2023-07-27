class CreateCompetitions < ActiveRecord::Migration[7.0]
  def change
    create_table :competitions do |t|
      t.string :name
      t.datetime :end_date
      t.string :unit_of_measurement

      t.timestamps
    end
  end
end
