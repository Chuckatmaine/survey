class CreateAnswerSets < ActiveRecord::Migration
  def self.up
    create_table :answer_sets do |t|
      t.integer :survey_id, :null => false
      t.integer :primary_affiliation_id, :null => false
    end
  end

  def self.down
    drop_table :answer_sets
  end
end
