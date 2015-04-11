class SurveysController < ApplicationController
  skip_before_filter :require_admin, :only => [:index,:show,:take,:submit,:edit,:new,:create,:destroy,:report,:update,:export_results] 
  # GET /surveys
  # GET /surveys.xml
  def index
    @surveys = Survey.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @surveys }
    end
  end

  # GET /surveys/1
  # GET /surveys/1.xml
  def show
    @survey = Survey.find(params[:id])

    respond_to do |format|
      if current_user.admin? || @survey.owner == current_user || @survey.editors.exists?(current_user)
        format.html # show.html.erb
        format.xml  { render :xml => @survey }
      else
        flash[:notice] = 'You are not allowed to view this survey.'
        format.html { redirect_to(surveys_url) }
        format.xml  { head :ok }
      end
    end
  end

  # GET /surveys/new
  # GET /surveys/new.xml
  def new
    @survey = Survey.new
    g = @survey.question_groups.build
    q = @survey.multiple_choice_questions.build
    3.times do 
      q.multiple_choice_options.build
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @survey }
    end
  end

  # GET /surveys/1/edit
  def edit
    @survey = Survey.find(params[:id])
    unless current_user.admin? || @survey.owner == current_user || @survey.editors.exists?(current_user)
      flash[:notice] = 'You are not allowed to edit this survey.'
      respond_to do |format|
        format.html { redirect_to(surveys_url) }
        format.xml  { head :ok }
      end
    end
    #g = @survey.question_groups.build
    #@survey.multiple_choice_questions.each do |mcq|
    #  mcq.multiple_choice_options.build
    #end
    #q = @survey.multiple_choice_questions.build
    #3.times do 
    #  q.multiple_choice_options.build
    #end
  end

  def take
    @survey = Survey.find(params[:id])
    @answer_set = AnswerSet.new(:survey_id => params[:id])
    #@survey.multiple_choice_questions.each do |q|
    #  @answer_set.multiple_choice_answers.build
    #end
    if user_submitted?
      respond_to do |format|
        flash[:notice] = 'You have already taken that survey.'
        format.html { redirect_to :action => 'index' }
        format.xml  { head :ok }
      end
    elsif !@survey.started?
      respond_to do |format|
        flash[:notice] = 'This survey is not open yet.'
        format.html { redirect_to :action => 'index' }
        format.xml  { head :ok }
      end
    elsif @survey.ended?
      respond_to do |format|
        flash[:notice] = 'This survey has ended.'
        format.html { redirect_to :action => 'index' }
        format.xml  { head :ok }
      end
    elsif !(current_user.faculty? || current_user.staff?)
      respond_to do |format|
        flash[:notice] = 'Only faculty or staff may take this survey'
        format.html { redirect_to :action => 'index' }
        format.xml  { head :ok }
      end
    end
  end


  # POST /surveys
  # POST /surveys.xml
  def create
    respond_to do |format|
      if current_user.admin? || current_user.creator?
        @survey = Survey.new(params[:survey])
        if @survey.save
          format.html { redirect_to(@survey, :notice => 'Survey was successfully created.') }
          format.xml  { render :xml => @survey, :status => :created, :location => @survey }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
        end
      else
        flash[:notice] = 'You are not allowed to create surveys.'
        format.html { redirect_to(surveys_url) }
        format.xml  { head :ok }
      end
    end

  end

  # PUT /surveys/1
  # PUT /surveys/1.xml
  def update
    @survey = Survey.find(params[:id])
    respond_to do |format|
      if current_user.admin? || @survey.owner == current_user || @survey.editors.exists?(current_user)
        if @survey.update_attributes(params[:survey])
          #logger.debug "survey: #{@survey.inspect}"
          format.html { redirect_to(@survey, :notice => 'Survey was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
        end
      else
        flash[:notice] = 'You are not allowed to update that survey.'
        format.html { redirect_to :action => 'index' }
        format.xml  { head :ok }
      end
    end
  end

  def submit
    @survey = Survey.find(params[:id])
    #logger.debug { params.inspect }


    if user_submitted?
      respond_to do |format|
        flash[:notice] = 'You have already taken that survey.'
        format.html { redirect_to :action => 'index' }
        format.xml  { head :ok }
      end
    elsif !@survey.started?
      respond_to do |format|
        flash[:notice] = 'This survey is not open yet.'
        format.html { redirect_to :action => 'index' }
        format.xml  { head :ok }
      end
    elsif @survey.ended?
      respond_to do |format|
        flash[:notice] = 'This survey has ended.'
        format.html { redirect_to :action => 'index' }
        format.xml  { head :ok }
      end
    elsif current_user.faculty? || current_user.staff?
      #@answers = Hash.new
      #params[:survey][:multiple_choice_questions_attributes].each do |tmpans|
      #  @answers[tmpans[0]['id']] = tmpans[0]['multiple_choice_options']
      #end
      #logger.debug { @answers.inspect }
  
        @submission = Submission.new
        @submission.survey = @survey
        @submission.user = current_user
        @answer_set = AnswerSet.new(params[:answer_set])
        @answer_set.survey_id = @survey.id
        @answer_set.primary_affiliation = current_user.primary_affiliation 
        @answer_set.affiliations = current_user.affiliations
        #logger.debug "answer_set: #{@answer_set.inspect}"
        #logger.debug "answer_set.multiple_choice_answers: #{@answer_set.multiple_choice_answers.inspect}"
  
        #@survey.multiple_choice_questions.each do |mcq|
        #  answer = @answers[mcq.id.to_s]
        #  if answer != nil
        #    option = mcq.multiple_choice_options.find(answer)
        #    option.multiple_choice_answers.build #.create( :faculty => current_user.faculty?, :staff => current_user.staff?)
        #    option.answer_set = @submission.answer_set
        #    option.save
        #  else
        #    raise NotAllQuestionsAnsweredError, 'Not all of the questions were answered!'
        #  end
        #end
      respond_to do |format|
        if @answer_set.save && @submission.save
          flash[:notice] = 'Thank you for taking the time to complete the survey. Your votes were recorded successfully.'
          format.html { redirect_to :action => 'index' }
          format.xml  { head :ok }
        else
          #logger.debug "answer_set_failed: #{@answer_set.inspect}"
          #logger.debug "answer_set_failed.multiple_choice_answers: #{@answer_set.multiple_choice_answers.inspect}"
          format.html { render :action => "take" }
          format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        flash[:notice] = 'Only faculty or staff may take this survey'
        format.html { redirect_to :action => 'index' }
        format.xml  { head :ok }
      end
    end
  rescue NotAllQuestionsAnsweredError => e
    respond_to do |format|
        flash[:notice] = 'You need to answer all of the questions.'
        format.html { render :action => "take" }
        format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
        format.html { render :action => "take" }
        format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.xml
  def destroy
    @survey = Survey.find(params[:id])
    if current_user.admin? || @survey.owner == current_user || @survey.editors.exists?(current_user)
      @survey.destroy
    else
      flash[:notice] = 'You are not allowed to destroy that survey.'
    end

    respond_to do |format|
      format.html { redirect_to(surveys_url) }
      format.xml  { head :ok }
    end
  end

  def user_submitted?
   return @survey.users.exists?( current_user.id )
  end

  def report
    @survey = Survey.find(params[:id])
    if current_user.admin? || @survey.owner == current_user || @survey.editors.exists?(current_user)
      @affiliation_totals = {}
      @survey.answer_sets.group(:primary_affiliation_id).count.map do |af_id, total|
        @affiliation_totals[Affiliation.find(af_id).title] = total
      end
      num_answer_sets = @survey.answer_sets.count
      @questions = {}
      @survey.multiple_choice_questions.each do |mcq|
        categories = ['Everyone'] 
        did_not_answer_data = { 'Everyone' => num_answer_sets }
        mcq.primary_affiliations.each do |prim_af|
          categories.push(prim_af.title)
          did_not_answer_data[prim_af.title] = @survey.answer_sets.where(:primary_affiliation_id => prim_af.id).count 
        end
        series = []
        total_answers = 0
        mcq.multiple_choice_options.each do |mco|
          everyone = mco.multiple_choice_answers.count
          total_answers += everyone
          #series_hash = {:type => 'column', :name => mco.title, :data => [everyone]}
          series_hash = {:type => 'column', :name => mco.title, :data => [everyone]}
          mcq.primary_affiliations.each do |pa|
            ca_total =  mco.multiple_choice_answers.where('answer_sets.primary_affiliation_id' => pa.id ).joins('left join answer_sets on multiple_choice_answers.answer_set_id = answer_sets.id').count
            series_hash[:data].push( ca_total )
            did_not_answer_data[pa.title] -= ca_total
            
            #series_hash[:data].push( 'mco.id: ' + mco.id.to_s + ' pa.id: ' + pa.id.to_s)
          end
          series.push(series_hash)
        end
        did_not_answer_data['Everyone'] -= total_answers
        did_not_answer_data_array = []
        categories.each do |ca|
          did_not_answer_data_array.push(did_not_answer_data[ca])
        end
  
        series.push({:type => 'column', :name => 'Did not answer', :data => did_not_answer_data_array})
        @questions[mcq.title] = { :id => mcq.id, :categories => categories, :series => series }
      end
    else
      flash[:notice] = 'You are not allowed view the report of that survey.'
      respond_to do |format|
        format.html { redirect_to(surveys_url) }
        format.xml  { head :ok }
      end
    end
  end

  def export_results
    @survey = Survey.find(params[:id])

    if current_user.admin? || @survey.owner == current_user || @survey.editors.exists?(current_user)
      csv_string = FCSV.generate do |csv|
        csv << [@survey.title, 'Total submissions:', @survey.submissions.count]
        @survey.questions.roots.each do |root_question|
          root_question.export(csv)
        end
      end
      filename = '"' + @survey.title + "_results_" + Date.today.to_s + ".csv\""
      send_data csv_string, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=" + filename
    else
      respond_to do |format|
        flash[:notice] = 'You are not allowed to the results of this survey.'
        format.html { redirect_to(surveys_url) }
        format.xml  { head :ok }
      end
    end
  end

  private

end
