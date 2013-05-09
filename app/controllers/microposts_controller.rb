class MicropostsController < ApplicationController

before_filter :signed_in_user, only: [:create, :destroy]
before_filter :correct_user, only: [:destroy]

def create

 @micropost = current_user.microposts.build(params[:micropost])
 if @micropost.save
 	flash[:success]="Micropost created"
 	redirect_to root_path
 else
 	@feed_items= []
 	render 'static_pages/home'     
 end
end

def destroy
  @micropost.destroy    # Here this destroy method is inbuilt method of Active record used to del a row
  redirect_to root_path
end

private 
 def correct_user
 	@micropost= current_user.microposts.find_by_id(params[:id])      # find vs find_by_id ..http://railsloft.com/posts/find-or-find_by_id
    redirect_to root_path if @micropost.nil?
                          # find_by_id returns nil if no record is found...but find returns 
                          # exception....As in pg 586
 end

end