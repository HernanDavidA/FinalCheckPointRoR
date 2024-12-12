class CreateArchives < ActiveRecord::Migration[7.2]
  def change
    create_table :archives do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end