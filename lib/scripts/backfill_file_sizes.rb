require 'net/http'

StoredFile.where(file_size: nil).find_each do |sf|
  next if sf.file.blank? || sf.file.url.blank?

  begin
    uri = URI(sf.file.url)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request_head(uri.request_uri)
    end

    if response.code.to_i == 200 && response['Content-Length']
      sf.update_column(:file_size, response['Content-Length'].to_i)
      puts "#{sf.id}: #{response['Content-Length']} bytes"
    else
      puts "SKIP #{sf.id}: HTTP #{response.code}"
    end
  rescue => e
    puts "ERROR #{sf.id}: #{e.message}"
  end
end
