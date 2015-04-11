class AffiliationsUsers < ActiveRecord::Migration
  def self.up
    create_table :affiliations_users, :id => false do |t|
      t.integer :affiliation_id, :null => false
      t.integer :user_id, :null => false
    end
  end

  def self.down
    drop_table :affiliations_users
  end
end
