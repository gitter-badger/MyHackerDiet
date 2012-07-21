class Emailer < ActionMailer::Base

  def contact(recipient, wlog, subject, sent_at = Time.now)
    @wlog = wlog
    @subject = subject
    @recipients = recipient
    @from = 'noreply@myhackerdiet.com'
    @sent_on = sent_at
    @content_type = 'text/html'
    @headers = { }

    default_url_options[:host] = 'myhackerdiet.com'
    
    mail(:from => @from, :to => @recipients, :subject => @subject)
  end


end
