class AnswerSet < ActiveRecord::Base
  belongs_to :survey
  belongs_to :primary_affiliation, :class_name => 'Affiliation'
  has_and_belongs_to_many :affiliations
  has_many :multiple_choice_answers, :dependent => :destroy, :validate => true
  accepts_nested_attributes_for :multiple_choice_answers, :reject_if => lambda { |a| a[:multiple_choice_option_id].blank? }, :allow_destroy => true
  validates :survey_id, :primary_affiliation_id, :presence => true
  validate :questions_answered

  private

  def questions_answered
    answer_hash = Hash.new
    self.multiple_choice_answers.each do |mca|
      #logger.debug "answer_hash.build: #{mca.inspect}"
      answer_hash[mca.multiple_choice_question_id] = true
    end
    #logger.debug "answer_hash: #{answer_hash.inspect}"
    self.survey.multiple_choice_questions.each do |mcq|
      #logger.debug "answer_hash.check: #{mcq.id.inspect}"
      if answer_hash.has_key?(mcq.id)
        answer_hash.delete(mcq.id)
      else
        if self.survey.all_answers || mcq.required
          errors.add(:multiple_choice_answer_attributes, 'You must answer the question (' + mcq.title + ')')
        end
      end
    end
    errors.add(:multiple_choice_answer, 'You answered an non-existant question!') unless answer_hash.empty?
  end
end
