class EditorsSurveys < ActiveRecord::Migration
  def self.up
    create_table :editors_surveys, :id => false do |t|
      t.references :survey, :null => false
      t.references :user, :null => false
    end
  end

  def self.down
    drop_table :editors_surveys
  end
end
