require 'twilio-ruby'
require 'dotenv/load'


module SmsTool

	def self.send_message(number = ENV['NUMBER'])
		time = Time.now.strftime("%I:%M%p")
		boot_twilio
		message = @client.api.account.messages.create(
  		from: '+442870032047',
  		to: number,
  		body: "Thank you! Your order was placed and will be delivered before #{time}.")
	end

	def self.boot_twilio
		@client = Twilio::REST::Client.new ENV['ACCOUNT_SID'], ENV['AUTH_TOKEN']
	end

end