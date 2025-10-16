class CreatePokeballs < ActiveRecord::Migration[7.1]
  def change
    create_table :pokeballs do |t|
      t.date :caught_on
      t.string :location
      t.references :trainer, null: false, foreign_key: true
      t.references :pokemon, null: false, foreign_key: true

      t.timestamps
    end
  end
end
