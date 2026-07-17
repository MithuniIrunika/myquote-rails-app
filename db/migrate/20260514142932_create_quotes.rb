class CreateQuotes < ActiveRecord::Migration[8.0]
  def change
    create_table :quotes do |t|
      t.text :qtext, null: false
      t.string :qyear, null: true
      t.text :qcom, null: true
      t.boolean :ispublic, default: false
      t.references :user, null: false, foreign_key: true
      t.references :philosopher, null: false, foreign_key: true

      t.timestamps
    end
  end
end
