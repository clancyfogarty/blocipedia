require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  let(:premium) { create(:user, role: :premium) }

  describe "Premium user actions" do
    before do
      sign_in premium
    end

    it "downgrades account successfully" do
      post :downgrade
      expect(premium.role).to eq(:standard)
    end
  end
end
