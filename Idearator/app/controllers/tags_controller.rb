
class TagsController < ApplicationController
  before_filter :authenticate_user! 
  
  # GET /tags
  # GET /tags.json
  # Author: Mohammad Abdulkhaliq
  def index
    if not user_signed_in? or current_user.type != 'Admin'
      render :text => "You Need To sign in as An Admin"
      return
    end
    @tags = Tag.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tags }
    end
  end
  
  # GET /tags/1
  # GET /tags/1.json
  # Author: Mohammad Abdulkhaliq
  def show
    if not user_signed_in? or current_user.type != 'Admin'
      render :text => "You Need To sign in as An Admin"
      return
    end
    @tag = Tag.find(params[:id])
    @tags = @tag.tags.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tag }
    end
  end
  
  # GET /tags/new
  # GET /tags/new.json
  # Author: Mohammad Abdulkhaliq
  def new
    if not user_signed_in? or current_user.type != 'Admin'
      render :text => "You Need To sign in as An Admin"
      return
    end
    @tag = Tag.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tag }
    end
  end
  
  # GET /tags/1/edit
  # Author: Mohammad Abdulkhaliq
  def edit
    if not user_signed_in? or current_user.type != 'Admin'
      render :text => "You Need To sign in as An Admin"
      return
    end
    @tag = Tag.find(params[:id])
  end
  
  # POST /tags
  # POST /tags.json
  #Create A new Tag
  #
  # * *Args*    :
  #   - +void+ ->
  # * *Returns* :
  #   - Show#Tag view
  # * *Raises* :
  #   - +PresenceError+ ->If nothing is entered on submit
  #   - +UniquenessError+ -> If Tag added is not unique	
  # Author: Mohammad Abdulkhaliq
  def create
    if not user_signed_in? or current_user.type != 'Admin'
      render :text => "You Need To sign in as An Admin"
      return
    end
    @tag = Tag.new(params[:tag])
    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag, notice: 'Tag was successfully created.' }
        format.json { render json: @tag, status: :created, location: @tag }
      else
        format.html { render action: "new" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /tags/1
  # PUT /tags/1.json
  # * *Args*    :
  #   - +tag.id+ ->
  # * *Returns* :
  #   - Show#Tag view
  # * *Raises* :
  #   - +PresenceError+ ->If nothing is entered on submit
  #   - +UniquenessError+ -> If new Tag name is not unique	
  # Author: Mohammad Abdulkhaliq
  def update
    if not user_signed_in? or current_user.type != 'Admin'
      render :text => "You Need To sign in as An Admin"
      return
    end
    @tag = Tag.find(params[:id])
    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  # * *Args*    :
  #   - +tag.id+ ->
  # * *Returns* :
  #   - Show#Tag view
  #Author: Mohammad Abdulkhaliq
  def destroy
    if not user_signed_in? or current_user.type != 'Admin'
      render :text => "You Need To sign in as An Admin"
      return
    end
    @tag = Tag.find(params[:id])
    @tag.destroy
    @tag.tags.destroy_all
    respond_to do |format|
      format.html { redirect_to tags_url }
      format.json { head :no_content }
    end
  end

  # Adds a Synonym with the name entered in the form
  # If the entered name does not have an associated tag with the same name
  # a new tag is created with the name and a connection is made
  # Else if the entered name already has a tag but without a connection  
  # a connection is made but a new tag is not created 
  # Else if the entered name already has a tag and a connection to the  
  # parent tag nothing is done and the user is informed so that the 
  # synonym already exists
  # * *Args*    :
  #   - +tag.id+ -> Tag id to add synonyms to
  # * *Returns* :
  #   - The updated Show#Tags/:id view 
  # * *Raises* :
  #   - +SynonymExistsNotice+ -> If Synonym added already exists in @tag.tags
  #
  def addsym
    if not user_signed_in? or current_user.type != 'Admin'
      render :text => "You Need To sign in as An Admin"
      return
    end
    @tag = Tag.find(params[:id])
    y = params[:tag]['name']
    #query for finding tag with input name returns Tag Array matching 'name'
    tag_query = Tag.where("name = ?", y)  
    respond_to do |format|
      if tag_query.empty?
        t = Tag.new(:name => y)
        if @tag.save
          format.html { redirect_to @tag, notice: 'Tag was successfully created. and Sym List appended' }
          format.json { render json: @tag, status: :created, location: @tag }
        else
          format.html { redirect_to @tag, notice: tag.errors.full_messages[0] }
          format.json { head :no_content }
        end
        t.tags << @tag
        @tag.tags << t
        format.html { redirect_to @tag, notice: 'Synonym was successfully created.' }
        format.json { head :no_content }
      elsif not @tag.tags.all.include?(tag_query[0]) and @tag != tag_query[0]
        t = tag_query[0]
        t.tags << @tag
        @tag.tags << t
        format.html { redirect_to @tag, notice: 'Synonym list was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @tag, notice: 'Synonym already exits !' }
        format.json { head :no_content }
      end
    end
  end
  
  def delsym
    @tag = Tag.find(params[:id])
    @tag2 = Tag.find(params[:sym])
    @tag.tags.destroy(@tag2)
    @tag2.tags.destroy(@tag)
    respond_to do |format|
      format.html { redirect_to @tag , notice: 'Synonym list was successfully updated.' }
      format.json { head :no_content }
    end
  end
end