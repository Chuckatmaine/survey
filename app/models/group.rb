class Group < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_uniqueness_of :dn, :allow_nil => true, :allow_blank => false
  validates_presence_of :name
  has_and_belongs_to_many :users
  #accepts_nested_attributes_for :multiple_choice_options, :allow_destroy => true
end
