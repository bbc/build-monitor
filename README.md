Build Monitor
=============

Usage
-----
Create a configuration.rb file like this:

```
set :hudson, "https://server/hudson"
set :project, "ProjectName"
set :certificate_pathname, "certificate.pem"
```

Copy your certificate into this directory and name it 'certificate.pem'

You can also add proxy server to yout configuration.rb file if you need to:

```
set :proxy_address, "your_proxy_address"
set :proxy_port, 80
```

Execute the launch script which will run rackup with nohup so it launches again after a crash.

```
./launch
```

The monitor is available at [http://localhost:9292/](http://localhost:9292/).
