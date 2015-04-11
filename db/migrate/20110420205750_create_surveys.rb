class CreateSurveys < ActiveRecord::Migration
  def self.up
    create_table :surveys do |t|
      t.string :title, :null => false
      t.text :description, :null => false
      t.datetime :start, :null => false
      t.datetime :end, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :surveys
  end
end
