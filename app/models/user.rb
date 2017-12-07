class User < ApplicationRecord
  # include default devise modules

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  private
  after_create :welcome_send

  def welcome_send
    WelcomeMailer.welcome_send(self).deliver
  end
end
