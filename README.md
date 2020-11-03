# ServicePatterns

How the [`interactor`](https://github.com/collectiveidea/interactor-rails) gem can help solve our service object woes.

The `Interactor` module abstracts away much of the boilerplate repeated for our service objects. It also fits into our single-method, single-responsibility service object ideology. In addition to less repeated code, here's a rundown of the major benefits:

- [x] Go-style error messaging between internal services.
- [x] Compose services and call them in order with `Organizer`s.
- [x] Share state between successive service calls via `#context`.
- [x] Hooks API to perform computations during service lifecycle.
- [x] Easy and consistent testing.

## Example

Using an interactor from a controller:

```rb
def charge
  response = ChargeSubscriptionService.call({ email: "foo@example.com" })

  if response.success?
    render json: response
  else
    raise response.errors
  end
end
```

Testing interactors:

```rb
describe ChargeSubscriptionService do
  let(:email)   { "foo@foo.com" }
  let(:context) { ChargeSubscriptionService.call(email: email) }

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
        expect(context.errors).to be_present
      end
    end
  end
end
```
