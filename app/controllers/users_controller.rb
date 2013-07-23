class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    @users = User.paginate(page: params[:page], per_page: 30).order('name COLLATE NOCASE ASC')
    # COLLATE NOCASE ASC orders the result irrespective of the whether the name is in uppercase or lowercase
  end
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    # @user = User.find(params[:id])  removed because becfore_action correct_user gets triggered 
  end
  
  def update
    # @user = User.find(params[:id]) removed because becfore_action correct_user gets triggered 
    if @user.update_attributes(user_params)
      #Handle a successful update
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_url
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  # Before filters
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in" 
    end
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user) 
    # Note: current_user? method has been defined in SessionsHelper module
  end
  
  def admin_user
    redirect_to(rooth_path) unless current_user.admin?
  end
end
