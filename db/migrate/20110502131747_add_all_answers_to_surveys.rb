class AddAllAnswersToSurveys < ActiveRecord::Migration
  def self.up
    add_column :surveys, :all_answers, :boolean,         :null => false, :default => 1
  end

  def self.down
    remove_column :surveys, :all_answers
  end
end
