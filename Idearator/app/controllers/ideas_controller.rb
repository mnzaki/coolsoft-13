class IdeasController < ApplicationController
  before_filter :authenticate_user!, :only => [:create , :edit, :update]
  # view idea of current user
  # Params
  # +id+:: is passed in params through the new idea view, it is used to identify the instance of +Idea+ to be viewed
  # Marwa Mehanna

  #plus 
#create new like
#Params:
#+comment_id+ :: the parameter is an instance
# of +Comment+ and it's used to build the like after clicking like
#The def checks if the user liked the comment before if not the num_likes is incremented
#by 1 else nothing happens
#author dayna

  def show
   @idea = Idea.find(params[:id])
    if user_signed_in?
    @user = current_user.id
    @username = current_user.username
   end
    @user=current_user.id
    if params[:commentid] != nil
   @commentid = params[:commentid]
   @comment = Comment.find(:first, :conditions => {:id => @commentid})
if Comment.exists?(:id => @commentid)
   @comment.num_likes = @comment.num_likes + 1
   @comment.save
   @like = Like.new
   @like.user_id = current_user.id
   @like.comment_id = @commentid
   @like.save
     redirect_to @idea
   else
    redirect_to @idea , :notice => "No Comment to delete"
end 
    @likes = Like.find(:all, :conditions => {:user_id => current_user.id})

  end

  end

  # making new Idea
  #Marwa Mehanna
  def new
    @idea = Idea.new
    @tags = Tag.all
    @chosentags = []
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @idea }
    end
  end
  # editing Idea
  # Params
  # +id+ :: this is an instance of +Idea+ passed through _form.html.erb, used to identify which +Idea+ to edit
  # Author: Marwa Mehanna
  def edit   
    @idea = Idea.find(params[:id])
    @tags = Tag.all
    @chosentags = Idea.find(params[:id]).tags
    @boolean = true
    @ideavoters = @idea.votes
    @ideacommenters = @idea.comments
    @userVreceivers = []
    @userCreceivers = []
    @usersthatcommented = []
    if !@idea.votes.nil?
    @ideavoters.each { |user|
       if user.participated_idea_notifications
        @userVreceivers << user 
      end }
      EditNotification.send_notification(current_user, @idea, @userVreceivers)
    end
    list_of_comments = Comment.where(idea_id: @idea.id)
    list_of_commenters = []
    list_of_comments.each do |c|
      list_of_commenters.append(User.find(c.user_id)).flatten!
    end
    list = list_of_commenters
    if list != nil
      EditNotification.send_notification(current_user, @idea, list)
    end
  end

  # updating Idea
  # Params
  # +ideas_tags:: this is an instance of +IdeasTag+ passed through _form.html.erb, this is where +tags+ will be added
  # +tags+ :: this is an instance of +Tags+ passed through _form.html.erb, used to identify which +Tags+ to add
  # Author: Marwa Mehanna
  def update
    @idea = Idea.find(params[:id])
    puts(params[:ideas_tags][:tags])
    @idea.tag_ids = params['ideas_tags']['tags'].collect { |t|t.to_i }
    respond_to do |format|
      if @idea.update_attributes(params[:idea])
        format.html { redirect_to @idea, notice: 'Idea was successfully updated' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # creating new Idea
  # Params
  # +idea+ :: this is an instance of +Idea+ passed through _form.html.erb, identifying the idea which will be added to records
  # +idea_tags+ :: this is an instance of +IdeaTags+ passed through _form.html.erb, this is where +tags+ will be added
  # +tags+ :: this is an instance of +Tags+ passed through _form.html.erb, used to identify which +Tags+ to add
  # Author: Marwa Mehanna
  def create
    @idea = Idea.new(params[:idea])
    @idea.user_id = current_user.id
    respond_to do |format|
      if @idea.save
        @tags = params[:ideas_tags][:tags]
        @tags.each do |tag|
          IdeasTags.create(:idea_id => @idea.id, :tag_id => tag)
        end
        format.html { redirect_to @idea, notice: 'idea was successfully created.' }
        format.json { render json: @idea, status: :created, location: @idea }
      else
        format.html { render action: 'new' }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end
end

