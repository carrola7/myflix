module StripeWrapper
  class Charge
    attr_reader :response, :status
    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options={})
      begin
        response = Stripe::Charge.create(amount: options[:amount], currency: 'eur', source: options[:source])
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end

    def successful?
      status == :success
    end

    def amount
      response.amount
    end

    def currency
      response.currency
    end

    def error_message
      response.message
    end
  end
end