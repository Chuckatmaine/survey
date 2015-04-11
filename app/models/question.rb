class Question < ActiveRecord::Base
  TYPES = ['QuestionGroup', 'MultipleChoiceQuestion']
  belongs_to :survey
  has_ancestry :orphan_strategy => :rootify
  acts_as_list :scope => :survey

  #has_many :multiple_choice_options, :order => :position, :dependent => :destroy
  #accepts_nested_attributes_for :multiple_choice_options, :allow_destroy => true
end
