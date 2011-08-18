Build Monitor
=============

Usage
-----
Create a configuration.rb file like this:

```
set :hudson, "https://server/hudson"
set :project, "ProjectName"
```

Copy your certificate into this directory and name it 'certificate.pem'

Execute the launch script which will run rackup with nohup so it launches again after a crash.

```
./launch
```

You can also set an http proxy before you launch

```
export http_proxy=http://path-to-proxy:port
./launch
```

The monitor is available at [http://localhost:9292/](http://localhost:9292/).
