class SubscribersController < ApplicationController
  before_action :authenticate_recruiter!
  before_action :set_company

  def new
    @plan = Plan.first
    @subscriber = Subscriber.new
  end

  def create
		coupon_code = !params[:coupon_code].empty? ? get_id_coupon(params[:coupon_code]) : ""
		@subscriber = Subscriber.new(company: @company)

		if coupon_code.nil?
			flash[:alert] = "Invalid coupon!"
			return render :new
		end

    plan = Plan.find_by(stripe_id: params[:plan])

    stripe_token = params[:stripeToken]

    billing_address = { line1: params[:address_line1], city: params[:address_city], state: params[:address_country], country: params[:address_state], postal_code: params[:address_zip] }

    if @subscriber.save_and_make_payment(current_recruiter.email, plan, stripe_token, billing_address, coupon_code)
       redirect_to dashboard_companies_path, notice: "Thanks for becoming a member of Find My Flock."
    else
      render :new
    end
  end

  def destroy
    @subscriber = Subscriber.find(params[:id])
    if @subscriber.active?
      sub = Stripe::Subscription.retrieve(@subscriber.stripe_subscription_id)
      begin
        sub.delete
        flash[:notice] = "Your subscription was canceled. You will still a member until the next billing period."
      rescue => e
        flash[:alert] = "Oops! An error has occurred. Please contant the support team at info@findmyflock.com."
      end
      redirect_to subscribers_path
    end
  end

  def set_company
    @company = current_recruiter.company
  end

	private

	COUPONS = {
    'FMF1' => 'fmf-1',
    'FMF2' => 'fmf-2',
    'LIConnections' => 'li-connections'
  }

  def get_id_coupon(code)
    # Normalize user input
    code = code.gsub(/\s+/, '')
    code = code.upcase
    COUPONS[code]
  end


end
