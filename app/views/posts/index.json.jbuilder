json.array!(@posts) do |post|
  json.extract! post, :id, :header, :post
  json.url post_url(post, format: :json)
end
