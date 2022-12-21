class DevelopersController < ApplicationController

  before_action :set_developer, except: %i[index create new]

  def new
    @developer = User.new
  end

  def create
    @developer = User.new(user_params)
    if @developer.save
      current_user.subordinates << @developer
      redirect_to developer_path(@developer)
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @developer.update(user_params)
      redirect_to developer_path(@developer)
    else
      render :edit
    end
  end

  def destroy
    if @developer.destroy
      respond_to do |format|
        format.html do
          flash[:success] = 'User removed successfully'
          redirect_to projects_path
        end
      end
    else
      flash[:failure] = 'User cant be deleted'
      redirect_to projects_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :user_name).tap { |additional_param| additional_param[:role] = 1 }
  end
  
  def set_developer
    @developer = User.find_by(id: params[:id])
  end
end
