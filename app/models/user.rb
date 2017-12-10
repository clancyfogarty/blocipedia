class User < ApplicationRecord
  # include default devise modules
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :wiki, dependent: :destroy
  before_save { self.role ||= :standard }

  enum role: [:standard, :premium, :admin]
end
