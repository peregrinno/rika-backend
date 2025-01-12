require_relative 'api_response'

module Validation
  include ApiResponse
  
  def validate_with(contract_class)
    contract = contract_class.new
    result = contract.call(@request_payload)
    
    if result.failure?
      halt ResponseData.error(result.errors.to_h, 422)
    end
    
    result.to_h
  end
end 