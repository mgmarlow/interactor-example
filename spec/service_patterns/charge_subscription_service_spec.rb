RSpec.describe ServicePatterns::ChargeSubscriptionService do
  let(:email)   { "foo@foo.com" }
  let(:context) { described_class.call(email: email) }

  describe "#call" do
    context "valid email" do
      let(:email) { "foo@foo.com" }

      it "succeeds" do
        expect(context).to be_a_success
      end

      it "charges the card" do
        expect(context.amount).to eq(50)
      end
    end

    context "invalid email" do
      let(:email) {}

      it "fails" do
        expect(context).to be_a_failure
      end

      it "provides error message" do
        expect(context.errors).to eq "Invalid email"
      end
    end
  end
end