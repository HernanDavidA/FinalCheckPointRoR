class AddUrlAndPublicIdToArchives < ActiveRecord::Migration[7.2]
  def change
    add_column :archives, :url, :string
    add_column :archives, :public_id, :string
  end
end
