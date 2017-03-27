class UserController < ApplicationController

  def loginreg
  end

  def create_user
    user = User.new(checking_account: 100, city: params[:city], state: params[:state], zip: params[:zip], phone: params[:phone], first_name: params[:first_name], last_name: params[:last_name], email: params[:email], password: params[:password], password_confirmation: params[:confirm_pw])
    if user.save
      User.create(checking_account: 100, city: params[:city], state: params[:state], zip: params[:zip], phone: params[:phone], first_name: params[:first_name], last_name: params[:last_name], email: params[:email], password: params[:password], password_confirmation: params[:confirm_pw])
      session[:user] = user
      session[:user_id] = user.id
      redirect_to "/"
    else
     flash[:errors] = user.errors.full_messages
     redirect_to "/login"
   end
 end

 def login
   user = User.find_by(email: params[:email])
   if user
     redirect_to "/"
   else
     flash[:errors] = ["Invalid login"]
     redirect_to "/login"
   end
 end

  def logout
    session.clear
    redirect_to "/login"
  end

end
