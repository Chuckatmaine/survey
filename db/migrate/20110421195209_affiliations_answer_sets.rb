class AffiliationsAnswerSets < ActiveRecord::Migration
  def self.up
    create_table :affiliations_answer_sets, :id => false do |t|
      t.integer :affiliation_id, :null => false
      t.integer :answer_set_id, :null => false
    end
  end

  def self.down
    drop_table :affiliations_answer_sets
  end
end
