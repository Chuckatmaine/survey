class Affiliation < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :primary_users, :class_name => 'User', :foreign_key => 'primary_affiliation_id'
end
