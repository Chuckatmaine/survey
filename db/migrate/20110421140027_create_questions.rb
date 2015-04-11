class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :survey_id, :null => false
      t.integer :position
      t.string :title, :null => false
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
