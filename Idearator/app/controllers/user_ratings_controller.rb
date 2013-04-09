class UserRatingsController < ApplicationController
  before_filter :authenticate_user!

  # creates a new user rating
  # Params:
  # +idea_id+:: is the id of the instance of +Idea+ which it's perspective will be rated
  # +user_rating:: is the actual +User_Rating+ attributes passed from the view
  # +rating_id+:: is the id of the instance of +Rating+, i.e Rating Perspective, which is being rated
  # Author: Mahmoud Abdelghany Hashish
  def create
    @idea = Idea.find_by_id(params[:idea_id])
    @user_rating = UserRating.new(params[:rating])
    @user_rating.rating_id = params[:rating_id]
    @user_rating.user_id = current_user.id
    if @user_rating.save
      respond_to do |format|
        format.html { redirect_to @idea, :notice => 'Your rating has been saved' }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to @idea, :notice => 'Your rating has not been saved, please retry!' }
        format.js
      end
    end
  end

  # updates an existing user rating
  # Params:
  # +idea_id+:: is the id of the instance of +Idea+ which it's perspective's rating will be updated
  # +user_rating:: is the actual +User_Rating+ attributes passed from the view to update the record
  # Author: Mahmoud Abdelghany Hashish
  def update
    @idea = Idea.find_by_id(params[:idea_id])
    @user_rating = current_user.user_ratings.find_by_rating_id(params[:rating_id])
    if @user_rating.update_attributes(params[:rating])
      respond_to do |format|
        format.html { redirect_to idea_path(@idea), :notice => 'Your rating has been updated' }
        format.js
      end
    else 
      respond_to do |format|
        format.html { redirect_to idea_path(@idea), :notice => 'Your rating has not been updated, please retry!' }
        format.js
      end
    end
  end
end