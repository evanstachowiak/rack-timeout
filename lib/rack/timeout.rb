require RUBY_VERSION < '1.9' && RUBY_PLATFORM != "java" ? 'system_timer' : 'timeout'
SystemTimer ||= Timeout

module Rack
  class Timeout
    @timeout = 15
    @timeout_block = nil
    class << self
      attr_accessor :timeout, :timeout_block
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      @timeout_block.call if @timeout_block
      SystemTimer.timeout(self.class.timeout, ::Timeout::Error) { @app.call(env) }
    end

  end
end
