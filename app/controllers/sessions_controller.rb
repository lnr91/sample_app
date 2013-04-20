class SessionsController < ApplicationController

def new
end

def create
	user=User.find_by_email(params[:session][:email])
	if user && user.authenticate(params[:session][:password]) # here authenticate is a function provided to us by has_secure_password (inbuilt fn) defined(not decribed) in User model
	# sign  the user in and show him his profule page
	sign_in user
	redirect_to user # this calls users controller and calls show action ..same as user_path(user)
    else
    	flash.now[:error]='Invalid email/password'
	    render 'new'
	end
end

def destroy
  sign_out
  redirect_to root_path
end







end
