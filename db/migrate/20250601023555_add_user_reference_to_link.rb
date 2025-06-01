class AddUserReferenceToLink < ActiveRecord::Migration[8.0]
  def change
    add_reference :links, :user, null: true, foreign_key: true
  end
end
