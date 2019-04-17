class Firm < ApplicationRecord
  belongs_to :firmtype
  has_many :education, :dependent => :destroy
  has_many :experience, :dependent => :destroy
end
