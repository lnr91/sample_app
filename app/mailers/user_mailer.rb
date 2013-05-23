class UserMailer < ActionMailer::Base
  default from: "simhaece@gmail.com"

  def new_follower(user,user_who_follows)
    @user = user       #we assign to instance variable bcos we want to access it in template ...o/w we cant access
    @user_who_follows= user_who_follows
    mail(to: user.email, subject: "You have a new follower" )
  end

  def registration_confirmation(user)
    @user = user
     mail(to: user.email, subject: "Confirmation email")
  end

  def password_reset(user)
    @user = user
    mail(to: user.email, subject: "Reset your password")
  end
end
