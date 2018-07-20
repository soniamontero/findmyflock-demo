class Subscriber < ActiveRecord::Base
  belongs_to :plan
  belongs_to :company

  enum status: [ :trialing, :active, :past_due, :canceled, :unpaid ]

  def save_and_make_payment(email, plan, card_token, billing_address, coupon_code)
    self.plan = plan
    if valid?
      begin
        customer = Stripe::Customer.create(
          source: card_token,
          email: email,
          description: "#{self.company.name}",
          shipping: {
            name: "#{self.company.name}",
            address: billing_address
          }
        )
        subscription = Stripe::Subscription.create({
          customer: customer.id,
          items: [{ plan: plan.stripe_id }],
          coupon: coupon_code
        })
        self.stripe_subscription_id = subscription.id
        self.stripe_customer_id = customer.id
        self.status = :active
        save
      rescue Stripe::CardError => e
        errors.add :credit_card, e.message
        false
      end
    else
      false
    end
  end
end
