module HeadersHelper
  def json_headers
    {
      "Content-Type" => "application/json",
      "ACCEPT" => "application/json"
    }
  end
end
