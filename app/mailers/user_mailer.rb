class UserMailer < ActionMailer::Base
  default from: "simhaece@gmail.com"

  def new_follower(user,user_who_follows)
    @user = user
    @user_who_follows= user_who_follows
    mail(to: user.email, subject: "You have a new follower" )
  end
end
