class AddPhotoToProduct < ActiveRecord::Migration[5.0]
  def up
    add_attachment :products, :photo
  end

  def down
    remove_attachment :products, :photo
  end
end