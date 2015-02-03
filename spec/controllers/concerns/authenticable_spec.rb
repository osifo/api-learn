require 'rails_helper'


class Authentication
	include Authenticable
end


describe Authenticable do
	let(:authentication) { Authentication.new }

	subject { authentication }

	describe "#current_user" do
		before do
			@user = FactoryGirl.create :user
			request.headers["Authorization"] = @user.auth_token
			authentication.stub(:request).and_return(request)
		end

		it "returns the user from the Authorization header" do
			expect(authentication.current_user.auth_token).to eql @user.auth_token 
		end
	end

	describe "#authenticate_with_token" do
		before do
			@user = FactoryGirl.create :user
			authentication.stub(:current_user).and_return(nil)
			response.stub(:response_code).and_return(401)
			response.stub(:body).and_return({ "errors" => "Not Authenticated" }.to_json)
			authentication.stub(:response).and_return(response)
		end

		it "should render a json error message" do
			expect(json_response[:errors]).to include "Not Authenticated"
		end
	end


	describe "#user_signed_in?" do
		context "when there is a user on 'session'" do
			before do
				@user = FactoryGirl.create :user
				authentication.stub(:current_user).and_return(@user)
			end

			it { should be_user_signed_in }
		end


		context "when there is no user on the 'session'" do
			before do
				@user = FactoryGirl.create :user
				authentication.stub(:current_user).and_return(nil) #we fake a null value for current_user
			end

			it { should_not be_user_signed_in }
		end
	end
end