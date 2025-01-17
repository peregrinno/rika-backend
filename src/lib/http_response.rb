module HttpResponse
  def error_response(message, status)
    [status, { 'Content-Type' => 'application/json' }, [message]]
  end

  def success_response(data, status = 200)
    [status, { 'Content-Type' => 'application/json' }, [data.to_json]]
  end
end 