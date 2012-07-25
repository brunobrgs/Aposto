require 'spec_helper'

describe Option do

	before (:each) do
		@user = FactoryGirl.create(:user, :credit => 20)
		User.current = @user
		@another_user = FactoryGirl.create(:user)
		@challenge = FactoryGirl.create(:challenge, :user_id => @user.id, :start_date => Date.today, :max_bets => 2, :bet_value => 10)
		5.times do
			@challenge.options << FactoryGirl.create(:option, :challenge => @challenge)
		end
	end

	it "can not be voted from other users if the challenge is not started" do
		User.current = @another_user
		@another_user.credit = 10
		@challenge.start_date = nil
		@challenge.save(:validate => false)
		opt = @challenge.options.first
		opt.vote(@another_user).should == false
	end

	it "can not be voted if the user don't have enouth credit" do
		@user.credit = 5
		opt = @challenge.options.first
		opt.vote(@user).should == false
	end

	it "can not be voted (any option of the challenge) two times from the same user" do
		@challenge.options.first.vote(@user).should == true
		@challenge.options.last.vote(@user).should == false
	end

	it "can not be voted (any option of the challenge) two times from the same user" do
		@challenge.options.last.vote(@user).should == true
		@challenge.options.first.vote(@user).should == false
	end


	describe "After create the vote" do

		it "Should create a User Vote" do
			opt = @challenge.options.last
			opt.vote(@user).should == true
			UserVote.where(:option_id => opt.id, :user_id => @user.id).size.should == 1
		end

		it "Should subtract the credit value" do
			value = @user.credit
			@challenge.options.last.vote(@user).should == true
			(value - @challenge.bet_value).should == @user.credit
		end

		it "Should be created a transaction log" do
			opt = @challenge.options.last
			opt.vote(@user).should == true
			user_vote = UserVote.where(:option_id => opt.id, :user_id => @user.id).limit(1).first
			tran = Transaction.where(:user_id => @user.id, :value => @challenge.bet_value)
			tran.select{|t| t.related == user_vote}.size.should == 1
		end

	end


end
