class QuestionGroup < Question
  #has_ancestry :orphan_strategy => :rootify
  def export(csv)
    csv << ['Group', self.title]
    if self.has_children?
      self.children.each do |child|
        child.export(csv)
      end
    end
  end
end
