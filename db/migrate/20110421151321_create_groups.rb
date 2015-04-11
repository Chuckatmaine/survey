class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
      t.string :dn

      t.timestamps
    end
    Group.create(:name => "Admin")
  end

  def self.down
    drop_table :groups
  end
end
