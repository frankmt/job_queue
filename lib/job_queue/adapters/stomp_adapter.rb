require 'stomp'

class JobQueue::StompAdapter
  def initialize(options = {})
    username = options[:username]
    password = options[:password]
    host = options[:host] || 'localhost'
    port = options[:port] || 61613
    @client = Stomp::Client.new(username, password, host, port)
  end
  
  def put(string)
    @client.send("job_queue", string)
  end
  
  def subscribe(error_report, &block)
    @client.subscribe("job_queue") do |job|
      begin
        JobQueue.logger.info "Stomp received #{job}"
        yield job
      rescue => e
        error_report.call(job, e)
      end
    end
  end
end
