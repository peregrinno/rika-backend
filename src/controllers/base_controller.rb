require_relative '../middlewares/auth_middleware'

class BaseController
  include Validation
  include ApiResponse
  include AuthMiddleware

  def initialize
    @request_payload = {}
  end

  def set_request_env(env)
    @env = env
  end
end 