class Thing < ApplicationRecord
  belongs_to :user
  belongs_to :thingtype
end
