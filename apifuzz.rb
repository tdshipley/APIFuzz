require_relative 'options'
require 'uri'
require 'json'
require 'cgi'
require 'http'

# Not using URI encode method to preserve raw string input
def build_params(params)
    result = ""

    params.each do |key, value|
        result << "#{key}=#{value}&"
    end

    return result.chomp("&")
end

def change_all_params_in_uri(uri, value)
    parsed_uri = URI(uri)

    return uri if parsed_uri.query.nil?

    params = CGI.parse(parsed_uri.query)

    params.keys.each { |key| params[key] = value }
    return "#{parsed_uri.scheme}://#{parsed_uri.host + parsed_uri.path}?#{build_params(params)}"
end

def get_inputs_from_file
    file = File.open "./resources/blns.json"
    inputs = JSON.parse(file.read)
    file.close

    return inputs
end

def make_request(uri)
    begin
        response = HTTP.get(uri)
    rescue
        pp "Request failed for #{uri}"
        result = {uri: uri, http_response_code: 0, body: "", api_fuzz_request_error: true}
        return result
    end
    
    result = {uri: uri, http_response_code: response.code, body: response.body.to_s, api_fuzz_request_error: false}
    return result
end

opts = Options.parse ARGV

inputs = get_inputs_from_file

pp "Making #{inputs.length} requests starting in 5 seconds..."

number = 5

while number != 0 do
    sleep(1)
    number -= 1
    pp "#{number.to_s}..."
end

pp "Sending requests..."

results = []

inputs.each do |input|
    fuzz_uri = change_all_params_in_uri(opts.target, input)
    result = make_request(fuzz_uri)

    pp result
    results << result
    sleep(0.25)
end

timestamp = Time.now.strftime("%d-%m-%Y-%H:%M")
filename = "./#{timestamp}_api_fuzz_result.json"

File.open(filename,"w") do |f|
    f.write(results.to_json)
end

pp "Results in json file: #{filename}"