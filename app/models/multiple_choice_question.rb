class MultipleChoiceQuestion < Question
  has_many :multiple_choice_options, :order => :position, :dependent => :destroy
  accepts_nested_attributes_for :multiple_choice_options, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true
  has_many :multiple_choice_answers
  has_many :primary_affiliations, :through => :multiple_choice_answers, :uniq => true

  def export(csv)
    csv << ['MultipleChoice', self.title]
    totals = Hash.new
    self.multiple_choice_options.each do |mco|
      totals[mco.title] = mco.multiple_choice_answers.count
    end
    csv << totals.keys
    csv << totals.values
    if self.has_children?
      self.children.each do |child|
        child.export(csv)
      end
    end
  end
end
