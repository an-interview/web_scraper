require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:review) { build(:review) }

  describe "validations" do
    it { should validate_numericality_of(:rating).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(5) }
    it { should validate_length_of(:comment).is_at_most(500) }
  end
end
