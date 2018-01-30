require "httparty"
require "json"
require "/Users/ericpeterson/development/Kele/lib/roadmap.rb"

 class Kele
   include HTTParty
   include Roadmap

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

   def get_mentor_availability(mentor_id)
     response = self.class.get(base_api_endpoint("mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
     @mentor_availability = JSON.parse(response.body)
   end

   def get_messages(page_number=1)
     response = self.class.get(base_api_endpoint("message_threads?#{page_number}"), headers: { "authorization" => @auth_token })
     @messages_page = JSON.parse(response.body)
   end

   def create_message(sender_email, recipient_id, stripped_text, subject )
     response = self.class.post(api_url("messages"), headers: { "authorization" => @auth_token }, body: { sender: sender_email, recipient_id: recipient_id, stripped_text: stripped_text, subject: subject })
     response.success? puts "message sent!"
   end
 private

   def base_api_endpoint(end_point)
     "https://www.bloc.io/api/v1/#{end_point}"
   end

 end
