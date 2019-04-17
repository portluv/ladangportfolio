class Firmtype < ApplicationRecord
    has_many :firm, :dependent => :destroy
end
