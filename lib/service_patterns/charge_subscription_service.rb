module ServicePatterns
  class ChargeCardService
    include Interactor

    def call
      if context.email
        context.amount = 50
      else
        context.fail!(errors: "Invalid email")
      end
    end
  end

  class SendEmailService
    include Interactor

    # Can use delegate in Rails to make context access more obvious
    # delegate :amount, :email, to: :context

    def call
      puts "Charged #{context.amount} to #{context.email}."
    end
  end

  # Organize single-purpose classes and call them in order.
  class ChargeSubscriptionService
    include Interactor::Organizer

    organize ChargeCardService, SendEmailService
  end

  # class ChargeSubscriptionService
  #   attr_accessor :email

  #   def initalize(email:)
  #     @email = email
  #   end

  #   def self.execute_call(email:)
  #     new(email: email).call
  #   end

  #   def call
  #     amount = ChargeCardService.execute_call(email: email)
  #     SendEmailService.execute_call(email: email, amount: amount)
  #   end
  # end
end
