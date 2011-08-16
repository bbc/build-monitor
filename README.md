Build Monitor
=============

Usage
-----
Create a configuration.rb file like this:
'''
set :hudson, "https://server/hudson/"
set :project, "ProjectName"
'''

Copy your certificate into this directory and name it 'certificate.pem'

Execute the launch script which will run rackup with nohup so it launches again after a crash.

'''
./launch
'''
