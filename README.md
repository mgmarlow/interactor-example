# Interactors for better services

How the [`interactor`](https://github.com/collectiveidea/interactor-rails) gem can help solve our service object woes.

`Interactor` is a drop-in module that abstracts away much of the service object boilerplate. Just like with our current service pattern in Beacons, interactors define a `#call` method that provides the single entry point to the service. However, unlike our current services, interactors also provide a standardized approach to handling errors, responses, and composition.

Here's a rundown of the major features `Interactor` provides:

- [x] Go-style error messaging between internal services.
- [x] Compose services and call them in order with `Organizer`s.
- [x] Share state between successive service calls via `#context`.
- [x] Hooks API to perform computations during service lifecycle.
- [x] Easy and consistent testing.

## Examples

View the example code in `/lib/service_patterns/charge_subscription_service.rb`.

```
# Configure packages
bundle

# Run the ruby console
./bin/console
=> result = ServicePatterns::ChargeSubscriptionService.call({ email: "foo@example.com" })
=> result.success? # true
=> result.amount # 50
```

Using an interactor from a Rails controller:

```rb
def charge
  response = ChargeSubscriptionService.call({ email: "foo@example.com" })

  if response.success?
    render json: { message: "Charged #{response.amount} to card." }
  else
    render json: { errors: response.errors }
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
