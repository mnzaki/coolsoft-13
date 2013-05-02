require 'spec_helper'

describe Coolster do

  describe 'add_to_online_users' do
    it 'adds the user id passed to it to the list of online users' do
      Coolster.add_to_online_users("1")
      expect(Coolster.online_user_ids).to include("1")
    end
  end

  describe 'remove_from_online_users' do
    it 'removes the user id passed to it from the list of online users' do
      Coolster.remove_from_online_users("1")
      expect(Coolster.online_user_ids).to_not include("1")
    end
  end

  describe 'update_all' do
  end

  describe 'update' do
  end

  describe 'update_each' do
  end

end