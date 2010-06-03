class Notifications < ActionMailer::Base
  def forgot_password(to, pass, sent_at = Time.now)
    @subject    = "Your new password is ..."
    @body['login'] = to
    @body['pass'] = pass
    @recipients = to
    @from       = 'support@yourdomain.com'
    @sent_on    = sent_at
    @headers    = {}
  end
end
