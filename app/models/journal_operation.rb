class JournalOperation < ActiveRecord::Base
  belongs_to :journal
  belongs_to :account
end
