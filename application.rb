unless File.exist?("certificate.pem")
  puts "Certificate file needs to be put in this directory and should be named 'certificate.pem'"
  exit(1)
end

require "json"
require "sinatra"

get "/" do
  project = "News"
  url = "https://ci-pal.int.bbc.co.uk/hudson/view/#{project}/api/json"
  response = `curl #{url} --cert certificate.pem --insecure`
  json = JSON.parse(response)
  jobs = json["jobs"].map do |job|
    HudsonJob.new(job["name"], job["color"])
  end
  haml :index, :locals => {:jobs => jobs}
end

class HudsonJob
  attr_accessor :name, :color
  def initialize(name, color)
    @name = name
    @color = color
  end
end

