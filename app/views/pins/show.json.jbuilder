json.extract! @pin, :id, :description, :created_at, :updated_at

json.array!(@pins) do |pin|
  json.extract! pin, :id, :description
  json.url pin_url(pin, format: :json)
end
