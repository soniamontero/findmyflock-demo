class StripeController < ApplicationController
  skip_forgery_protection

  class SubscriberNotFoundError < StandardError
    def initialize(stripe_customer_id)
      @stripe_customer_id = stripe_customer_id
    end

    def message
      "Subscriber not found with stripe_customer_id #{@stripe_customer_id}"
    end
  end

  def webhooks
    event_json = JSON.parse(request.body.read)
    return true if event_json["id"] == "evt_00000000000000" #Testing webhooks from dashboard

    event = Stripe::Event.retrieve(event_json["id"])

    case event.type
    when 'customer.subscription.created'
      subscriber = Subscriber.find_by(stripe_customer_id: event.data.object.customer)
      raise SubscriberNotFoundError.new(event.data.object.customer) unless subscriber

      subscriber.subscribed_at = Time.at(event.data.object.start).to_datetime
      subscriber.subscription_expires_at = Time.at(event.data.object.current_period_end).to_datetime
      subscriber.status = event.data.object.status
      if subscriber.save
        logger.debug "---------------------- Subscription updated! ----------------------"
      end

    when 'customer.subscription.updated'
      subscriber = Subscriber.find_by(stripe_customer_id: event.data.object.customer)
      raise SubscriberNotFoundError.new(event.data.object.customer) unless subscriber

      subscriber.subscription_expires_at = Time.at(event.data.object.current_period_end).to_datetime
      subscriber.plan = Plan.where(stripe_id: event.data.object.items.data[0].plan.id).first
      subscriber.status = event.data.object.status
      if subscriber.save
        logger.debug "---------------------- Subscription updated! ----------------------"
      end

    when 'customer.subscription.deleted'
      subscriber = Subscriber.find_by(stripe_customer_id: event.data.object.customer)
      raise SubscriberNotFoundError.new(event.data.object.customer) unless subscriber

      subscriber.subscription_expires_at = Time.at(event.data.object.current_period_end).to_datetime
      subscriber.status = event.data.object.status
      if subscriber.save
        logger.debug "---------------------- Subscription updated! ----------------------"
      end

    when 'invoice.payment_succeeded'
      subscriber = Subscriber.find_by(stripe_customer_id: event.data.object.customer)
      raise SubscriberNotFoundError.new(event.data.object.customer) unless subscriber

      subscription = Stripe::Subscription.retrieve(subscriber.stripe_subscription_id)
      subscriber.subscription_expires_at = Time.at(subscription.current_period_end).to_datetime
      subscriber.status = subscription.status
      if subscriber.save
        logger.debug "---------------------- Subscription updated! ----------------------"
      end
    end

    render status: :ok, json: "success"
  end
end
