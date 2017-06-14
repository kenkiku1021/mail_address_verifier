require "mail_address_verifier/version"
require "resolv"
require "net/smtp"

module MailAddressVerifier
  # Your code goes here...

  def MailAddressVerifier.get_domain(mail_address)
    if mail_address =~ /^[^@]+@(.+)$/
      domain = $1
    else
      raise "Invalid mail address format."
    end
  end
  
  def MailAddressVerifier.get_mx(domain)
    Resolv::DNS.new.getresources(domain, Resolv::DNS::Resource::IN::MX)\
      .sort_by {|r| r.preference}\
      .map {|r| r.exchange.to_s}
  end

  def MailAddressVerifier.verify_by_smtp(mail_address, myhost, myaddress)
    mx = get_mx(get_domain(mail_address)).first
    result = false
    Net::SMTP.start(mx) do |smtp|
      smtp.helo myhost
      smtp.mailfrom myaddress
      begin
        smtp.rcptto mail_address
        result = true
      rescue
      end
    end
    result
  end

  def MailAddressVerifier.verify_by_domain(mail_address)
    result = false
    begin
      mx = get_mx(get_domain(mail_address))
      unless mx.empty?
        result = true
      end
    rescue
      result = false
    end
    result
  end
end
