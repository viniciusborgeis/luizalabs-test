class AddModalityRefToCompetitions < ActiveRecord::Migration[7.0]
  def change
    add_reference :competitions, :modality, null: false, foreign_key: true
  end
end
