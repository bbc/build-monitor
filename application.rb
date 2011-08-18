
unless File.exist?("certificate.pem")
  puts "Certificate file needs to be put in this directory and should be named 'certificate.pem'"
  exit(1)
end

unless File.exist?("configuration.rb")
  puts "Configuration file does not exist. It should be called 'configuration.rb' and should contain the following contents:"
  puts <<-CONFIG
  set :hudson, "https://ci-pal.int.bbc.co.uk/hudson/"
  set :project, "News"
  CONFIG
end

require "json"
require "sinatra"
require "haml"
require File.join(File.dirname(__FILE__), "configuration")

get "/" do
  url = "#{settings.hudson}/view/#{settings.project}/api/json"

  curl = "curl #{url} --cert certificate.pem --insecure"
  curl << " -x #{ENV['http_proxy']}" if (ENV["http_proxy"])
  response = `#{curl}`
 
  begin
    json = JSON.parse(response)
    jobs = json["jobs"].map do |job|
      HudsonJob.new(job["name"], job["color"])
    end
    haml :index, :locals => {:jobs => jobs}
  rescue  
    haml :json_error
  end
  

end

class HudsonJob
  attr_accessor :name, :color
  def initialize(name, color)
    @name = name
    @color = color
  end
end

