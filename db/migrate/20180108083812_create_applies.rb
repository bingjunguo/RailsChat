class CreateApplies < ActiveRecord::Migration
  def change
    create_table :applies do |t|
      t.string :user_id, index: true
      t.string :friend_id, index: true

      t.timestamps null: false
    end
  end
end
