class UsersController < ApplicationController
before_action :signed_in_user, only: [:edit, :update, :index, :destroy]
before_action :correct_user,   only: [:edit, :update]
before_action :admin_user,     only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  	@user=User.new
  end

  def create 
  	@user=User.new(user_params)
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		flash.now[:fail] ="Are you serious? Fill in the entire form!"
  		render 'new'
  	end
  end

  def destroy
    User.find(params[:id]).destroy
  flash[:success] = "Another one bites the dust!"
  redirect_to users_url
  end

  def edit 
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
      flash.now[:fail] = "Your changes were not updated successfully"
    end
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers 
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private 

  def user_params 
  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  #Before filters

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
