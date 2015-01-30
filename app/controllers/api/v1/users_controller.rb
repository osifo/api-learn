class Api::V1::UsersController < ApplicationController
	respond_to :json

	def show
		respond_with User.find(params[:id])
	end


	def create
		user  = User.new(user_params)

		if user.save
			render json: user, status: 201, location: [:api, user]
		else
			render json: { errors: user.errors }, status: 422 #error code for unprocessable entity
		end
	end


	def update
		user = User.find(params[:id])
		user.update(user_params)

		if user.save
			render json: user, status: 200, location: [:api, user]
		else
			render json: { errors: user.errors }, status: 422 #unprocessable entity
		end
	end

	private 

		def user_params
			params.require(:user).permit(:email, :password, :password_confirmation)
		end
end
