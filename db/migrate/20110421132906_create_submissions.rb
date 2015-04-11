class CreateSubmissions < ActiveRecord::Migration
  def self.up
    create_table :submissions do |t|
      t.integer :user_id, :null => false
      t.integer :survey_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :submissions
  end
end
