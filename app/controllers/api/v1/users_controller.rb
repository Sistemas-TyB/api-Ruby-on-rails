
class Api::V1::UsersController < ApplicationController
  before_action :validate_user, except: [:index]
  before_action :set_user, only: [:update]
  before_action :authenticate, except: [:create,:login]
  def index
    @users = User.all
  end
  def login
    @user = User.from_login(user_params)
    #raise @user.valid_password?(params[:user][:password]).to_json
    if @user.valid_password?(params[:user][:password])
      @token = Token.new(user_id: @user.id)
      if @token.save
          json_encode = {token: @token.token}
          @token.token = JWT.encode(json_encode, @key)
          render "api/v1/users/show"
      else 
        render json: {response: t('credentials.invalid')}, status: :bad_request
      end
    else
      render json: {response: t('credentials.user_invalid')}, status: :bad_request
    end
  end
  def create
    @user = User.new(user_params)
    if @user.save
      @token = Token.new(user_id: @user.id) #new -> #create -> #save
      if @token.save
        json_encode = {token: @token.token}
        @token.token = JWT.encode(json_encode, @key)
        render "api/v1/users/show"
      else 
        render json: {response: t('credentials.error'), status: :bad_request}, status: :bad_request
      end
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
  def update
    if @user.id == @current_user.id #cancancan
      if @user.update(user_params)
        render "api/v1/users/update"
      else    
        render json: {response: t('crud.update_error'), status: :bad_request}, status: :bad_request
      end
    else
      render json: {response: t('credentials.error'), status: :bad_request}, status: :bad_request
    end
  end
  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
  def validate_user
    if !params[:user].present? # Que exista la key y que no este vacío el objeto del key
      render json: {:message => t('messages.add_name')}
    end
  end
  def set_user
    begin
  	  @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {:message => t('messages.dont_find')}
    end
  end
end