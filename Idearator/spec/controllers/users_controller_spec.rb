require 'spec_helper'
describe UsersController do
  include Devise::TestHelpers
  describe "responding to GET show" do
    before(:each) do
      @user = FactoryGirl.build(:user)
      @user.confirm!
      sign_in @user
    end
    it "should expose the requested user as @user and render [show] template" do
      @new_user = FactoryGirl.build(:user_two)
      @new_user.confirm!
      get :show, :id => @new_user.id
      assigns[:user].should == @new_user
      response.should render_template("users/show")
    end
  end
  describe "PUT change_settings" do
    it "changes user settings" do
      u= User.new
      u.email="test1@gmail.com"
      u.username= "sameh"
      u.password= "123123123"
      u.confirm!
      u.save
      sign_in u
      put :change_settings, :user=> ['1']
      u.reload
      u.own_idea_notifications.should eq(true)
      u.participated_idea_notifications.should eq(false)
    end
    it "changes user settings" do
      u1= User.new
      u1.email="test1@gmail.com"
      u1.username= "sameh"
      u1.password= "123123123"
      u1.confirm!
      u1.save
      sign_in u1
      put :change_settings, :user=> []
      u1.reload
      u1.own_idea_notifications.should eq(false)
      u1.participated_idea_notifications.should eq(false)
    end
  end
end