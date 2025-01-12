class BaseController
  include Validation
  include ApiResponse

  def initialize
    @request_payload = {}
  end
end 