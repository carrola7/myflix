require 'spec_helper'

describe StripeWrapper::Charge do
  let(:token) do
    Stripe::Token.create({
      card: {
        number: card_number,
        exp_month: 5,
        exp_year: 2020,
        cvc: '314',
      },
    }).id
  end
  context 'with valid card' do
    let(:card_number) { '4242424242424242' }
    it 'charges the card successfully', :vcr do

      response = StripeWrapper::Charge.create(amount: 999, source: token)
      expect(response).to be_successful
      expect(response.amount).to eq(999)
      expect(response.currency).to eq('eur')
    end
  end
  context 'with invalid card' do
    let(:card_number) { '4000000000000002'}
    let(:response) { StripeWrapper::Charge.create(amount: 300, source: token) }
    it 'does not charge the card successfully', :vcr do
      expect(response).to_not be_successful      
    end
    it 'contains an error message', :vcr do
      expect(response.error_message).to eq('Your card was declined.')
    end
  end
end