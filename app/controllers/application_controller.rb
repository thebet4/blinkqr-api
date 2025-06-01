class ApplicationController < ActionController::API
    def encode_token(payload, exp = 2.minutes.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, Rails.application.credentials.secret_key_base)
    end

    def decode_token
        auth_header = request.headers["Authorization"]
        if auth_header
            token = auth_header.split(" ").last
            begin
                JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: "HS256")
            rescue JWT::DecodeError
                nil
            end
        end
    end

    def authorized_user
        decoded_token = decode_token()
        if decoded_token
            user_id = decoded_token[0]["user_id"]
            @user = User.find_by(id: user_id)
        end
    end

    def authorize
        authorized_user()
        if !@user
            render json: { message: "Unauthorized" }, status: :unauthorized
        end
    end

    def current_user
        access_token = request.headers["Authorization"].split(" ").last
        if access_token
            begin
                decoded_token = JWT.decode(access_token, Rails.application.credentials.secret_key_base, true, algorithm: "HS256")
                user_id = decoded_token[0]["user_id"]
                @user = User.find_by(id: user_id)
            rescue JWT::DecodeError
                nil
            end
        end
    end
end
