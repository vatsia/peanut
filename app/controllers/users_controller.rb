class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    if not current_user.nil?
      @users = User.all
    else
      redirect_to posts_path
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if not current_user.nil?
      render 'users/show'
    else
      redirect_to posts_path
    end
  end

  # GET /users/new
  def new
    if not current_user.nil?
      @user = User.new
      render 'users/new'
    else
      redirect_to posts_path
    end
  end

  # GET /users/1/edit
  def edit
    if not current_user.nil?
      render 'users/edit'
    else
      redirect_to posts_path
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if not current_user.nil?
      respond_to do |format|
        if @user.save
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to posts_path
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update

    if not current_user.nil?
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to posts_path
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy

    if not current_user.nil?
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to posts_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
end
