require 'job_queue/job_queue'

JobQueue.autoload 'AMQPAdapter', 'job_queue/adapters/amqp_adapter'
JobQueue.autoload 'BeanstalkAdapter', 'job_queue/adapters/beanstalk_adapter'