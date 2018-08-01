class StripeController < ApplicationController
  def webhooks
    event_json = JSON.parse(request.body.read)
    return true if event_json["id"] == "evt_00000000000000" #Testing webhooks from dashboard

    event = Stripe::Event.retrieve(event_json["id"])
  
    if event.type =~ /^customer.subscription.created/
      subscriber = Subscriber.find_by(stripe_customer_id: event.data.object.customer)
      subscriber.subscribed_at = Time.at(event.data.object.start).to_datetime
      subscriber.subscription_expires_at = Time.at(event.data.object.current_period_end).to_datetime
      subscriber.status = event.data.object.status
      if subscriber.save
        logger.debug "---------------------- Subscription updated! ----------------------"
      end
    end

    if event.type =~ /^customer.subscription.updated/
      subscriber = Subscriber.find_by(stripe_customer_id: event.data.object.customer)
      subscriber.subscription_expires_at = Time.at(event.data.object.current_period_end).to_datetime
      subscriber.plan = Plan.where(stripe_id: event.data.object.items.data[0].plan.id).first
      subscriber.status = event.data.object.status
      if subscriber.save
        logger.debug "---------------------- Subscription updated! ----------------------"
      end
    end

    if event.type =~ /^customer.subscription.deleted/
      subscriber = Subscriber.find_by(stripe_customer_id: event.data.object.customer)
      subscriber.subscription_expires_at = Time.at(event.data.object.current_period_end).to_datetime
      subscriber.status = event.data.object.status
      if subscriber.save
        logger.debug "---------------------- Subscription updated! ----------------------"
      end
    end

    if event.type =~ /^invoice.payment_succeeded/
      subscriber = Subscriber.find_by(stripe_customer_id: event.data.object.customer)
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
