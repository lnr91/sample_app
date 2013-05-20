class RelationshipsController < ApplicationController

  before_filter :signed_in_user, only: [:create,:destroy]     # why not [create,destroy]..why use symbols ?

  def create
  @user= User.find(params[:relationship][:followed_id])
  current_user.follow!(@user)

  UserMailer.new_follower(@user,current_user).deliver
  respond_to do |format|
  format.html { redirect_to @user }   # eqvlnt to redirect_to user_path(@user)
  format.js
  end
  end

  def destroy
    @user= Relationship.find(params[:id]).followed       #here params[:id] is provided by form_for
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }   # eqvlnt to redirect_to user_path(@user)
      format.js
    end
  end
end