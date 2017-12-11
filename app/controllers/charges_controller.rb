class ChargesController < ApplicationController

  AMOUNT = 1500

  def new
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "Premium Membership - #{current_user.email}",
      amount: AMOUNT
    }
  end

  def create
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: AMOUNT,
      description: "Premium Membership - #{current_user.email}",
      currency: 'usd'
    )

    if charge
      flash[:notice] = "Your account has been upgraded, #{current_user.email}!"
      current_user.premium!
      redirect_to wikis_path
    end

    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to new_charge_path
    end
  end
