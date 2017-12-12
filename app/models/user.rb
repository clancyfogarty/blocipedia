class User < ApplicationRecord
  # include default devise modules
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :wikis, dependent: :destroy

  has_many :collaborators
  has_many :collab_wikis, through: :collaborators, source: :wiki
  
  before_save { self.role ||= :standard }

  enum role: [:standard, :premium, :admin]
end
