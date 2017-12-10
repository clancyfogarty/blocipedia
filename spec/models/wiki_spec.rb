require 'rails_helper'

RSpec.describe Wiki, type: :model do
  let(:user) { create(:user) }
  let(:wiki) { create(:wiki) }

  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_presence_of(:user) }

  describe "attributes" do
    it "has a title, body, user, and private attribute" do
      expect(wiki).to have_attributes(title: wiki.title, body: wiki.body, private: wiki.private, user: wiki.user)
    end
  end
end
