unless File.exist?("certificate.pem")
  puts "Certificate file needs to be put in this directory and should be named 'certificate.pem'"
  exit(1)
end

unless File.exist?("configuration.rb")
  puts "Configuration file does not exist. It should be called 'configuration.rb' and should contain the following contents:"
  puts <<-CONFIG
  set :hudson, "https://your_server/hudson"
  set :project, "News"

  # if behind a proxy server
  set :proxy_address, "your_proxy_address"
  set :proxy_port, 80
  CONFIG
end

require "json"
require "sinatra"
require "haml"
require File.join(File.dirname(__FILE__), "configuration")

get "/" do
  url = "#{settings.hudson}/view/#{settings.project}/api/json"

  if settings.respond_to? :proxy_address
    http = Net::HTTP::Proxy(settings.proxy_address, settings.proxy_port).new(uri.host, uri.port)
  else
    http = Net::HTTP.new(uri.host, uri.port)
  end
  
  pem = File.read File.join(File.dirname(__FILE__), "certificate.pem")
  http.use_ssl     = true
  http.cert        = OpenSSL::X509::Certificate.new pem
  http.key         = OpenSSL::PKey::RSA.new pem
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request  = Net::HTTP::Get.new uri.request_uri
  response = http.request request

  jobs = get_jobs_from_json response.body

  haml :index, :locals => {:jobs => jobs, :settings => settings}
end

def get_jobs_from_json json
  json = JSON.parse(json) rescue nil
  jobs = nil
  if json
    json["jobs"].map do |job|
      HudsonJob.new(job["name"], job["color"])
    end
  end
end

class HudsonJob
  attr_accessor :name, :color
  def initialize(name, color)
    @name = name
    @color = color
  end
end
