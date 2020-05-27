class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
 has_many :tokens
 #validates :email, uniqueness: true, presence: true
 validates :password, presence: true
 def self.from_login(data)
    u = User.where("email = ?", data[:email]).first
 end

end
