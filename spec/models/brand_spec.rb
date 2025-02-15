require 'rails_helper'

RSpec.describe Brand, type: :model do
  let(:brand) { build(:brand) }

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
