class CreatePhilosophers < ActiveRecord::Migration[8.0]
  def change
    create_table :philosophers do |t|
      t.string :fname, null: false
      t.string :lname, null: true
      t.string :byear, null: true
      t.string :dyear, null: true
      t.text :bio, null: true

      t.timestamps
    end
  end
end
