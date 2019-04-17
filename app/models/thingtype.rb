class Thingtype < ApplicationRecord
    has_many :thing, :dependent => :destroy
end
