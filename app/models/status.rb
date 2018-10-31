class Status < ApplicationRecord
  belongs_to :thing
  belongs_to :user
end
