class AffiliationsController < ApplicationController
  # GET /affiliations
  # GET /affiliations.xml
  def index
    @affiliations = Affiliation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @affiliations }
    end
  end

  # GET /affiliations/1
  # GET /affiliations/1.xml
  def show
    @affiliation = Affiliation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @affiliation }
    end
  end

  # GET /affiliations/new
  # GET /affiliations/new.xml
  def new
    @affiliation = Affiliation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @affiliation }
    end
  end

  # GET /affiliations/1/edit
  def edit
    @affiliation = Affiliation.find(params[:id])
  end

  # POST /affiliations
  # POST /affiliations.xml
  def create
    @affiliation = Affiliation.new(params[:affiliation])

    respond_to do |format|
      if @affiliation.save
        format.html { redirect_to(@affiliation, :notice => 'Affiliation was successfully created.') }
        format.xml  { render :xml => @affiliation, :status => :created, :location => @affiliation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @affiliation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /affiliations/1
  # PUT /affiliations/1.xml
  def update
    @affiliation = Affiliation.find(params[:id])

    respond_to do |format|
      if @affiliation.update_attributes(params[:affiliation])
        format.html { redirect_to(@affiliation, :notice => 'Affiliation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @affiliation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /affiliations/1
  # DELETE /affiliations/1.xml
  def destroy
    @affiliation = Affiliation.find(params[:id])
    @affiliation.destroy

    respond_to do |format|
      format.html { redirect_to(affiliations_url) }
      format.xml  { head :ok }
    end
  end
end
