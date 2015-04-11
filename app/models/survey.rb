class Survey < ActiveRecord::Base

  validates_uniqueness_of :title
  has_many :questions, :order => :position
  accepts_nested_attributes_for :questions, :allow_destroy => true
  has_many :question_groups, :dependent => :destroy
  accepts_nested_attributes_for :question_groups, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true
  has_many :multiple_choice_questions, :dependent => :destroy
  accepts_nested_attributes_for :multiple_choice_questions, :reject_if => lambda { |a| a[:title].blank? }, :allow_destroy => true
  has_many :multiple_choice_options, :through => :multiple_choice_questions, :dependent => :destroy
  #accepts_nested_attributes_for :multiple_choice_options, :allow_destroy => true
  has_many :submissions, :dependent => :destroy
  has_many :users, :through => :submissions
  belongs_to :owner, :class_name => "User"
  has_and_belongs_to_many :editors, :class_name => "User", :join_table => 'editors_surveys'
  has_many :answer_sets
  
  def user_taken(user)
    if self.users.find(user.id)
      return true
    else
      return false
    end
  rescue ActiveRecord::RecordNotFound
    return false
  end

  def started?
    if self.start == nil || Time.now > self.start
      return true
    else
      return false
    end
  end

  def ended?
    if self.end != nil && Time.now > self.end
      return true
    else
      return false
    end
  end
end
