require 'bundler'
Bundler.require

Docker.url = 'tcp://foo.alxb.us:2375'

$last_ts = 0

# Action on all events after a given time (will execute the block for all events up till the current time, and wait to execute on any new events after)
#Docker::Event.since(1416958763) { |event| puts event; puts Time.now.to_i; break }

class EventStreamer
  include Celluloid

  def initialize
    puts 'starting event streamer...'
    stream
  end

  def stream
    Docker::Event.since($last_ts) do |event|
      #binding.pry
      puts event
      $last_ts = event.time
    end
  end
end

class ContainerActor
  include Celluloid

  def initialize
  end
end


class DockerEventsContainer < Celluloid::Supervision::Container
  supervise type: EventStreamer, as: :streamer
end

DockerEventsContainer.run!

puts :foo
binding.pry
puts :foobar
