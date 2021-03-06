require "bunny"
require "rest_client"

connection = Bunny.new
connection.start

channel = connection.create_channel
q = channel.queue("generic", :durable => true, :auto_delete => false)

q.subscribe do |delivery_info, properties, payload|
  puts "[consumer] #{q.name} received a message: #{payload}"
  response = RestClient.post 'http://localhost:4567/api/1.0/event/151',
              :data => payload, :content_type => :json, :accept => :json
end

sleep 3.5
puts "Disconnecting..."
connection.close
