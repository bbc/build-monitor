unless File.exist?("certificate.pem")
  puts "Certificate file needs to be put in this directory and should be named 'certificate.pem'"
  exit(1)
end

unless File.exist?("configuration.rb")
  puts "Configuration file does not exist. It should be called 'configuration.rb' and should contain the following contents:"
  puts <<-CONFIG
  set :hudson, "https://your_server/hudson"
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
  json = `#{curl}`

  jobs = get_jobs_from_json json
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
