require_relative 'api_response'

module Validation
  include ApiResponse

  def validate_with(contract_class)
    puts "Starting validation with contract: #{contract_class}"
    puts "Request Payload Type: #{@request_payload.class}"
    puts "Request Payload: #{@request_payload.inspect}"
    
    # Garante que temos um hash, mesmo que vazio
    input = @request_payload.is_a?(Hash) ? @request_payload : {}
    
    # Se o input estiver vazio, retorna erro
    if input.empty?
      return ResponseData.error({ base: ['Dados inválidos ou ausentes'] }, 422)
    end
    
    # Converte as chaves para símbolos
    input = input.transform_keys(&:to_sym)
    
    contract = contract_class.new
    result = contract.call(input)
    
    if result.failure?
      return ResponseData.error(result.errors.to_h, 422)
    end
    
    result.to_h
  end
end 