class StreamController < ApplicationController

  #This is the action that controls the stream through having 4 aparameters manipulated in a way that they change the
  #value of the @ideas that is sent
  # params:
  # +mypage+:: int
  # +search+:: string
  # +tag+:: Intstance of tag
  # +search_user+:: boolean is sent to true to search for users
  # Author: Mohamed Salah Nazir
  @@filter_all = []

  def search
    @searchtext = params[:search]
    @searching_with = params[:searchtype] == "true"
    if !@searching_with
      @search_results = Idea.search(@searchtext)
    else
      @search_results = User.search(@searchtext)
    end
  end

  def index
    @trending = Idea.joins(:trend).order('trending desc').limit(4)
    @top = Idea.find(:all, :conditions => { :approved => true }, :order=> 'num_votes desc', :limit=>10)
    @page = params[:mypage]
    @searching_with = params[:searchtype] == "true"
    @insert = params[:insert]

    if MonthlyWinner.all.count > 0
      @winners = MonthlyWinner.all.reverse
      first = @winners.shift
      @first = Idea.find(first.idea_id)
    end

    if params[:reset_global]
      @@filter_all = []
    end

    if params[:set_global]
      @@filter_all = params[:tag].to_a
      @filter_tmp = @@filter_all
    else
      @filter_tmp = @@filter_all+params[:tag].to_a
    end

    if @page.nil?
      @@filter_all = []
      @ideas = Idea.order(:created_at).reverse
      @ideas = Kaminari.paginate_array(@ideas).page(params[:mypage]).per(20)
    else
      if @filter_tmp != []
        @ideas = Idea.filter(@filter_tmp,"").sort{|i1,i2| i1.created_at <=> i2.created_at}.uniq
        @ideas = @ideas.reverse
        @ideas = Kaminari.paginate_array(@ideas).page(params[:mypage]).per(20)
        @filter_tmp.uniq
      else
        @ideas = Idea.order(:created_at).reverse
        @ideas = Kaminari.paginate_array(@ideas).page(params[:mypage]).per(20)
      end
    end
  end
end


