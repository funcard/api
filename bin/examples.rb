#!/usr/bin/env ruby

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'dotenv'
end

require 'dotenv/load'
require 'net/http'
require 'uri'
require 'json'
require 'openssl'

sections_dir = File.join(__dir__, '..', 'sections')
markdown_files = Dir.glob(File.join(sections_dir, '*.md'))

if markdown_files.empty?
  puts "No markdown files found in #{sections_dir}"
  exit 1
end

markdown_files.each do |file|
  content = File.read(file)
  
  # Find START comment with URL (supports both relative paths and full URLs)
  if content =~ /<!-- START (\w+) ([^\s]+) -->/
    method = $1
    path_or_url = $2
    
    # Build full URL: if it's a relative path, prefix with SERVER_URL
    if path_or_url.start_with?('/')
      server_url = ENV['SERVER_URL']
      if server_url.nil? || server_url.empty?
        puts "Error: SERVER_URL environment variable is required for relative paths"
        exit 1
      end
      # Remove trailing slash from SERVER_URL if present
      server_url = server_url.chomp('/')
      url = "#{server_url}#{path_or_url}"
    else
      url = path_or_url
    end
    
    # Make request
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme == 'https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    
    # Set X-API-KEY header from environment variable
    request = Net::HTTP::Get.new(uri.request_uri)
    api_key = ENV['API_KEY'] || ENV['FUNCARD_API_KEY']
    if api_key
      request['X-API-KEY'] = api_key
    end
    
    response = http.request(request)
    
    # Check response status
    unless response.is_a?(Net::HTTPSuccess)
      puts "  Warning: HTTP #{response.code} for #{url}"
      puts "  Response body: #{response.body[0..200]}"
      next
    end
    
    # Parse and format JSON
    begin
      json = JSON.pretty_generate(JSON.parse(response.body))
    rescue JSON::ParserError => e
      puts "  Error: Failed to parse JSON response for #{url}: #{e.message}"
      puts "  Response body: #{response.body[0..200]}"
      next
    end
    
    # Replace JSON block between START and END (keep original path format in comment)
    # Match JSON block whether it's empty or already has content
    # Handle both empty (```json\n```\n) and non-empty (```json\ncontent\n```\n) cases
    pattern = /<!-- START #{Regexp.escape(method)} #{Regexp.escape(path_or_url)} -->\n```json\n([\s\S]*?)\n?```\n<!-- END -->/
    replacement = "<!-- START #{method} #{path_or_url} -->\n```json\n#{json}\n```\n<!-- END -->"
    content.gsub!(pattern, replacement)
    
    File.write(file, content)
    puts "Updated #{file}"
  else
    puts "No START comment found in #{file}"
  end
end
