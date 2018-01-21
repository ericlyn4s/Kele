require "httparty"
require "json"

 class Kele
   include HTTParty


   def initialize(email, password)
     response = self.class.post(base_api_endpoint("sessions"), body: { "email": email, "password": password })
     puts response.code
     raise "Invalid email or password" if response.code == 404
     @auth_token = response["auth_token"]
   end

   def get_me
     response = self.class.get(base_api_endpoint("users/me"), headers: { "authorization" => @auth_token }) 
     @user_data = JSON.parse(response.body)
     @user_data
   end

 private

   def base_api_endpoint(end_point)
     "https://www.bloc.io/api/v1/#{end_point}"
   end

 end
