require 'spec_helper'

describe Challenge do

  before (:each) do
    @user = FactoryGirl.create(:user)
    @challenge = FactoryGirl.create(:challenge, :user_id => @user.id)
    @options = FactoryGirl.create(:option, :challenge => @challenge)
  end

  it "Should belongs to user" do
    @challenge.belong_to(@user).should == true
  end

end
