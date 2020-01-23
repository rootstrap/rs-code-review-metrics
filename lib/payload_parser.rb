module PayloadParser
  def parse_payload(payload)
    JSON.parse(payload.to_json, object_class: OpenStruct)
  end
end
