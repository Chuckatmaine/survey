class UserSessionsController < ApplicationController
  skip_before_filter :require_user, :only => [:new,:create]
  skip_before_filter :require_admin
  before_filter CASClient::Frameworks::Rails::Filter, :only => [:create]
  before_filter :require_no_user, :only => [:new,:create]

  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  def new
    @user_session = UserSession.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_session }
    end
  end

  # POST /user_sessions
  # POST /user_sessions.xml
  def create
      if session[:cas_user] != nil
        logger.debug { "cas_user\n" }
        @user = User.find_by_employee_number(session[:cas_extra_attributes][:employeeNumber][0])
        if @user != nil
          logger.debug { "@user\n" }
          @user.autoupdate
        else
          logger.debug { "no @user\n" }
          @user = User.new({ :username => session[:cas_user] })
          @user.employee_number =  session[:cas_extra_attributes][:employeeNumber][0] #.sub(/^"(.*)"$/, '\1')
          @user.ldap_update
        end
        @user_session = UserSession.new(@user)
      else
        logger.debug { "no cas_user\n" }
        @user_session = UserSession.new(params[:user_session])
      end

      #respond_to do |format|
        if @user_session.save
          flash[:notice]  = 'Login Successful.'
          logger.debug @user_session.user.username + ' has successfully logged in.\n'
          redirect_back_or_default surveys_url
          #redirect_to new_drop_url
        else
          @user_session.errors.each_full { |msg| logger.debug msg }
          redirect_to login_url
          #format.html { render :action => "new" }
          #format.xml  { render :xml => @user_session.errors, :status => :unprocessable_entity }
        end
      #end
  end

  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.xml
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    respond_to do |format|
      format.html { redirect_to(login_url, :notice => 'Goodbye!') }
      format.xml  { head :ok }
    end
  end
end
