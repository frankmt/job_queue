require 'stomp'

class JobQueue::StompAdapter
  def initialize(options = {})
    username = options[:username]
    password = options[:password]
    host = options[:host] || 'localhost'
    port = options[:port] || 61613
    @conn = Stomp::Connection.new(username, password, host, port, true)
  end
  
  def put(string)
    @conn.send("/queue/job_queue", string, :persistent => true)
  end
  
  def subscribe(error_report, &block)
      @conn.subscribe("/queue/job_queue")
      loop do
        begin
          job = @conn.receive
          JobQueue.logger.info "Stomp received #{job}"
          yield job.body
        rescue => e
          error_report.call(job, e)
        end
      end
  end
end
