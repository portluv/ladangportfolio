json.extract! profile, :id, :name, :content, :created_at, :updated_at
json.url profile_url(profile, format: :json)
