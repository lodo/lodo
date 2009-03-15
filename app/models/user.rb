require 'digest/sha1'

class User < ActiveRecord::Base
  validates_length_of :login, :within => 3..40
  validates_length_of :password, :within => 5..40
  validates_presence_of :login, :email, :password, :salt
  validates_uniqueness_of :login
  validates_confirmation_of :password
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"  
  attr_protected :id, :salt
  has_and_belongs_to_many :companies

  
  def password=(pass)
    @password=pass
    if pass
      self.salt = User.random_string(6) if !self.salt?
      self.hashed_password = User.encrypt(@password, self.salt)
    end
  end

  def password
    @password
  end
  
  def self.authenticate(login, pass)
    u=find(:first, :conditions=>["login = ?", login])
    return nil if u.nil?
    return u if User.encrypt(pass, u.salt)==u.hashed_password
    nil
  end  
  
  def send_new_password
    new_pass = User.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    Notifications.deliver_forgot_password(self.email, self.login, new_pass)
  end

  protected

  def self.encrypt(pass, salt)
    print "Pass: "
    print pass 
    print ". Salt:" 
    print salt 
    print ".\n"
    Digest::SHA1.hexdigest(pass+salt)
  end

  def self.random_string(len)
    #generate a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a + "!#%&/()=?+@-_<>[]{}*".to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
  
end
