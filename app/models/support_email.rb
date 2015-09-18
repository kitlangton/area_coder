class SupportEmail
  def initialize
    @gmail = Gmail.connect('kit.langton@coloredge.com', 'NY100user')
  end

  def pending
    @gmail.inbox.emails(:unread, from: "donotreply@vzretailsupport.com").map do |mail|
      message = SupportMessage.new
      message.email = mail.subject.match(/\((.+)\)/)[1]
      message.phone_number = mail.body.match(/phone: *(\d.+)username/)[1].scan(/\d/).join
      message.area = DecipherArea.new(number: message.phone_number).region
      message.uid = mail.subject
      message
    end
  end

  def send(message, recipient, uid)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})
    @gmail.deliver do
      to recipient + ", joe.buchheri@coloredge.com, jeff.reardon@coloredge.com"
      subject "Verizon Card Creator Login Information"
      html_part do
        content_type 'text/html; charset=UTF-8'
        body markdown.render(message) +
        '<div style="font-family:Calibri,sans-serif;font-size:14px"><span style="font-family:Futura;font-size:12px"><font color="#ff6600">Kit Langton</font>&nbsp;| Client Tech Support</span></div>' +
        '<div style="font-size:14px;font-family:Calibri,sans-serif"><font face="Futura" style="font-size:12px">(C) 973 619 3946</font></div>' +
        '<div style="font-size:14px;font-family:Calibri,sans-serif"><font face="Futura" style="font-size:12px"><a href="mailto:kit.langton@coloredge.com" style="color:purple" target="_blank">kit.langton@coloredge.com</a>&nbsp;&nbsp;|&nbsp;<a href="http://coloredge.com/" style="color:purple" target="_blank">www.coloredge.com</a>&nbsp;</font></div>'
      end
    end
    @gmail.inbox.find(subject: uid).each(&:read!)
  end
end

class SupportMessage < Struct.new(:email, :phone_number, :uid, :area);end
