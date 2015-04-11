class MultipleChoiceOption < ActiveRecord::Base
  belongs_to :multiple_choice_question
  has_many :multiple_choice_answers
  has_many :primary_affiliations, :through => :multiple_choice_answers
  acts_as_list :scope => :multiple_choice_question
end
