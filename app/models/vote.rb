class Vote < ApplicationRecord
  belongs_to :work
  belongs_to :user

  validates :user, uniqueness: {scope: :work,
                        message: "User can only vote on this work one time"}
end
