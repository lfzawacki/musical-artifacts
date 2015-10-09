json.array!(@artifacts) do |artifact|
  json.partial! 'artifacts/artifact', artifact: artifact
end
