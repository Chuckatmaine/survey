class CreateMultipleChoiceOptions < ActiveRecord::Migration
  def self.up
    create_table :multiple_choice_options do |t|
      t.integer :multiple_choice_question_id, :null => false
      t.integer :position
      t.string :title, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :multiple_choice_options
  end
end
