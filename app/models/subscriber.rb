class Subscriber < ActiveRecord::Base
  belongs_to :plan
  belongs_to :company

  enum status: [ :trialing, :active, :past_due, :canceled, :unpaid ]

  delegate :name, :stripe_id, to: :plan, prefix: true

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
        subscription = Stripe::Subscription.create(
          customer: customer.id,
          items: [{ plan: plan.stripe_id }],
          coupon: coupon_code.present? ? coupon_code : nil
        )
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

  def cancel!
    subscription = Stripe::Subscription.retrieve stripe_subscription_id
    subscription.delete at_period_end: true
    update status: :canceled, subscription_expires_at: Time.at(subscription.current_period_end)
  end
end
