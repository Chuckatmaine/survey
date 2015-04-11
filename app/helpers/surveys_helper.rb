module SurveysHelper
  def display_questions(survey)
    output = Array.new
    output.push("\n<ol>\n")
    survey.questions.roots.each do |root_question|
        output.push(nested_questions( root_question ))
    end
    output.push("\n</ol>\n")
    output.join.html_safe
  end
  def display_questions_report(survey)
    output = Array.new
    output.push("\n<ol>\n")
    survey.questions.roots.each do |root_question|
        output.push(nested_questions_report( root_question ))
    end
    output.push("\n</ol>\n")
    output.join.html_safe
  end
  def display_questions_take(survey, answer_set, f)
    output = Array.new
    output.push("\n<ol>\n")
    survey.questions.roots.each do |root_question|
        output.push(nested_questions_take( root_question, answer_set, f ))
    end
    output.push("\n</ol>\n")
    output.join.html_safe
  end
  def display_questions_fields_for(survey, f)
    output = Array.new
    output.push("\n<ol>\n")
    survey.questions.roots.each do |root_question|
        output.push(nested_questions_fields_for( root_question, f ))
    end
    output.push("\n</ol>\n")
    output.push("\n<p>New Questions</p>\n")
    output.push("\n<ul>\n")
    Question::TYPES.each do |type|
      new_question = survey.send(type.underscore + 's').build
      output.push(render(:partial => 'new_' + type.underscore + '_fields_for', :locals => { :question => new_question, :f => f }) )
    end
    output.push("\n</ul>\n")
    output.join.html_safe
  end
  def nested_questions( question )
    output = Array.new
    output.push("\n<li>\n")
    output.push(render(:partial => question.type.to_s.underscore, :locals => { :question => question }) )
    if question.has_children?
      output.push("\n<ol>\n")
      question.children.each do |child|
        output.push(nested_questions( child ))
      end
      output.push("\n</ol>\n")
    end
    output.push("\n</li>\n")
    output.join.html_safe
  end 
  def nested_questions_report( question )
    output = Array.new
    if question.type == "MultipleChoiceQuestion"
      output.push("\n<li class='question_report'>\n")
    else
      output.push("\n<li>\n")
    end
    output.push(render(:partial => question.type.to_s.underscore + '_report', :locals => { :question => question }) )
    if question.has_children?
      output.push("\n<ol>\n")
      question.children.each do |child|
        output.push(nested_questions_report( child ))
      end
      output.push("\n</ol>\n")
    end
    output.push("\n</li>\n")
    output.join.html_safe
  end 
  def nested_questions_take( question, answer_set, f )
    output = Array.new
    output.push("\n<li>\n")
    output.push(render(:partial => question.type.to_s.underscore + '_take', :locals => { :question => question, :answer_set => answer_set, :f => f }) )
    if question.has_children?
      output.push("\n<ol>\n")
      question.children.each do |child|
        output.push(nested_questions_take( child, answer_set, f ))
      end
      output.push("\n</ol>\n")
    end
    output.push("\n</li>\n")
    output.join.html_safe
  end 
  def nested_questions_fields_for( question, f )
    output = Array.new
    output.push("\n<li>\n")
    output.push(render(:partial => question.type.to_s.underscore + '_fields_for', :locals => { :question => question, :f => f }) )
    if question.has_children?
      output.push("\n<ol>\n")
      question.children.each do |child|
        output.push(nested_questions_fields_for( child, f ))
      end
      output.push("\n</ol>\n")
    end
    output.push("\n</li>\n")
    output.join.html_safe
  end 
end
