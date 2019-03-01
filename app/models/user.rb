class User < ApplicationRecord
    has_one :profile, :dependent => :destroy
    has_many :thing, :dependent => :destroy
    has_many :status, :dependent => :destroy

    validates :username, presence: true, length: { minimum: 4 }
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX, message: 'is invalid'} 
    
    validates :password, presence: true, length: { minimum: 8 }
end
