class AddCreatorsAndEditorsGroups < ActiveRecord::Migration
  def self.up
    Group.create(:name => "Creators")
    Group.create(:name => "Editors")
    Group.create(:name => "Owners")
  end

  def self.down
    Group.find_by_name("Creators").destroy
    Group.find_by_name("Editors").destroy
    Group.find_by_name("Owners").destroy
  end
end
