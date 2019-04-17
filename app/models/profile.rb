class Profile < ApplicationRecord
  belongs_to :user, optional: true
  has_many :education, :dependent => :destroy
  accepts_nested_attributes_for :education, allow_destroy: true, update_only: true
  has_many :experience, :dependent => :destroy
  accepts_nested_attributes_for :experience, allow_destroy: true, update_only: true
  has_many :speciality, :dependent => :destroy
  accepts_nested_attributes_for :speciality, allow_destroy: true, update_only: true
end
