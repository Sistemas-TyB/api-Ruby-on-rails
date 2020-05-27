class ApplicationController < ActionController::Base

  class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session#:exception
    before_action :set_locale
    #before_action :authenticate
    private
    rescue_from CanCan::AccessDenied do |exception|
      render json: {message: t('rules.dont_permission')}, status: :unauthorized
    end
    def current_ability
     @current_ability ||= Ability.new(@current_user)  	
    end
    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
      @key = Rails.application.secrets.secret_key_base
    end
    def authenticate
      #raise params['token'].to_json
      #raise request.headers['token'].to_json
      if !request.headers["token"].nil? # 
        token_frontend = request.headers["token"]
        #raise JWT.decode(token_frontend, @key)[0].to_json
        decode = JWT.decode(token_frontend, @key)[0] 
        json_decode = HashWithIndifferentAccess.new decode
        #raise json_decode.to_json
        token = Token.find_by(token:json_decode[:token])
        if token.nil? or not token.is_valid?
          render json: {message: "Tu token es invalido"},status: :unauthorized
        else
          @current_user = token.user
        end  
      else
        render json: {message: "No se obtuvieron parametros esperados"},status: :unauthorized
      end
    end
    rescue_from JWT::VerificationError do |exception|
      #raise exception.to_json
      render json: {:message => t('jwt.decode_error')}, status: :unprocessable_entity    
    end
  end