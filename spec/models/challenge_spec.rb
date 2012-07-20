require 'spec_helper'

describe Challenge do

  before (:each) do
    @user = FactoryGirl.create(:user)
    User.current = @user
    @another_user = FactoryGirl.create(:user)
    @challenge = FactoryGirl.create(:challenge, :user_id => @user.id)
    5.times do
    	@challenge.options << FactoryGirl.create(:option, :challenge => @challenge)
    end
  end

  it "Should belong to user" do
    @challenge.belong_to(@user).should == true
  end

  it "Should not belong to user" do
    @challenge.belong_to(@another_user).should == false
  end

  it "Should return all the answers with it id" do
  	@challenge.answers_with_id.each do |answer_with_id|
  		opt = Option.find(answer_with_id[1])
  		answer_with_id[0].should == opt.answer
  	end
  end

  it "Should not be iniciated" do
  	@challenge.initiated?.should == false
  end

  it "Should create the first vote" do
  	FactoryGirl.create(:user_vote, :user => @user, :option => @challenge.options.first)
  	@challenge.votes.size.should == 1
  end

  it "Should be iniciated" do
  	@challenge.start_date = Date.today
  	@challenge.initiated?.should == true
  end

  it "Can/Cannot be voted" do
  	@challenge.start_date = nil
  	User.current = @another_user
  	@challenge.can_be_voted?.should == false
  	User.current = @user
  	@challenge.can_be_voted?.should == true
  end

  it "Should return the list of votes related to the challenge" do
  	FactoryGirl.create(:user_vote, :user => @user, :option => @challenge.options.first)
  	FactoryGirl.create(:user_vote, :user => @another_user, :option => @challenge.options.first)
  	votes = UserVote.includes(:option).where("options.challenge_id = #{@challenge.id}")
  	votes.should == @challenge.votes
  end

  describe "Editing" do

	  it "Just the user who create can change the challenge" do
	  	User.current = @another_user
	  	@challenge.can_be_changed?.should == false
	  	User.current = @user
	  	@challenge.can_be_changed?.should == true
	  end

	  it "Cannot be changed if it is initialized" do
	  	User.current = @user
	  	@challenge.start_date = Date.today
	  	@challenge.can_be_changed?.should == false
	  end

	  it "Can be changed if it is not initialized, by the user who create" do
	  	User.current = @user
	  	@challenge.can_be_changed?.should == true
	  end

  end

end
