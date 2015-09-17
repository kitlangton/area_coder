class SupportEmail
  def initialize
    @gmail = Gmail.connect('kit.langton@coloredge.com', 'NY100user')
  end

  def pending
    @gmail.inbox.emails(from: "donotreply@vzretailsupport.com").map do |mail|
      message = SupportMessage.new
      message.email = mail.subject.match(/\((.+)\)/)[1]
      message.phone_number = 123
      message
    end
  end
end

class SupportMessage < Struct.new(:email, :phone_number);end
