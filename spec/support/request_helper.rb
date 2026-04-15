module RequestHelper
  def json_request(method, path, params: {}, headers: {})
    send(
      method,
      path,
      params: params.to_json,
      headers: json_headers.merge(headers)
    )
  end
end
