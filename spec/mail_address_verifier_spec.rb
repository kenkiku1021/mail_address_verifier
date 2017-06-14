require 'spec_helper'

VALID_ADDRESS = 'ken@nuasa.org'
INVALID_ADDRESS = 'invalid_address@nuasa.org'
INVALID_DOMAIN_ADDRESS = 'invalid_address@example.com'
MYHOST = 'localhost'

describe MailAddressVerifier do
  it 'has a version number' do
    expect(MailAddressVerifier::VERSION).not_to be nil
  end

  it 'get domain from mail address' do
    address = "test@example.com"
    domain = MailAddressVerifier.get_domain(address)
    expect(domain).to eq "example.com"
  end

  it 'should raise error when mail address is invalid' do
    address = "test"
    expect{ MailAddressVerifier.get_domain(address) }.to raise_error( RuntimeError )
  end
  
  it 'get mx record from domain name' do
    mx = MailAddressVerifier.get_mx("nuasa.org")
    expect(mx).not_to be nil
  end

  describe 'mail address verificaton by smtp' do
    it 'verify valid mail address' do
      expect(MailAddressVerifier.verify_by_smtp(VALID_ADDRESS, MYHOST, VALID_ADDRESS)).to eq true
    end

    it 'verify invalid mail address' do
      expect(MailAddressVerifier.verify_by_smtp(INVALID_ADDRESS, MYHOST, VALID_ADDRESS)).to eq false
    end
  end

  describe 'mail domain verification' do
    it 'verify valid mail domain' do
      expect(MailAddressVerifier.verify_by_domain(VALID_ADDRESS)).to eq true
    end

    it 'verify invalid mail domain' do
      expect(MailAddressVerifier.verify_by_domain(INVALID_DOMAIN_ADDRESS)).to eq false
    end
  end
  
end
