class MultipleChoiceAnswer < ActiveRecord::Base
  belongs_to :answer_set, :validate => true
  belongs_to :multiple_choice_question
  belongs_to :multiple_choice_option
  has_many :primary_affiliations, :through => :answer_set

  #validates :multiple_choice_question, :multiple_choice_option, :presence => true
  #validate :option_matches_question

  private

  def option_matches_question
    errors.add(:multiple_choice_option, 'Option must match Question') unless self.multiple_choice_question.multiple_choice_options.exists?(self.multiple_choice_option_id)
  end
end
