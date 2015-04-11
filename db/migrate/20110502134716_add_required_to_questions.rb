class AddRequiredToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :required, :boolean,         :null => false, :default => 0
  end

  def self.down
    remove_column :questions, :required
  end
end
