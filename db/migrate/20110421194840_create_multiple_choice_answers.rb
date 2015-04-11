class CreateMultipleChoiceAnswers < ActiveRecord::Migration
  def self.up
    create_table :multiple_choice_answers do |t|
      t.integer :multiple_choice_question_id, :null => false
      t.integer :multiple_choice_option_id, :null => false
      t.integer :answer_set_id, :null => false
    end
  end

  def self.down
    drop_table :multiple_choice_answers
  end
end
