class Option < ActiveRecord::Base
  belongs_to :challenge
  attr_accessible :answer
end
