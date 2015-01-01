knockd cookbook
---------------
[![Build Status](https://travis-ci.org/nephilagraphic-cookbooks/knockd.svg?branch=master)](https://travis-ci.org/nephilagraphic-cookbooks/knockd)

Installs and configures knockd.


Requirements
------------

None


Platform
--------

Tested on

* Ubuntu 12.04
* Ubuntu 13.04
* Debian 7.4


Usage
-----

Include the `knockd::default` recipe to start using knockd.

```ruby
include_recipe 'knockd'

knockd_sequence 'openHTTP' do
  sequence ['7000', '8000', '9000:tcp']
  tcpflags :syn
  on_open '/sbin/iptables -A INPUT -s %IP% -p tcp --dport 80 -j ACCEPT'
end

knockd_sequence 'https' do
  sequence [ '2123', '2124:tcp', '2125:udp' ]
  tcpflags [ :syn, :ack ]
  on_open 'echo https open'
end
```


Attributes
----------

- `['knockd']['enabled']` - Enables or disables knockd.  default true.
- `['knockd']['interface']` - Make knockd listen to a specific interface.  default nil.


Recipes
-------

### default
Provides LWRP for knockd.  Note that by default, knockd service is disabled.


Definitions/Resources/Providers
-------------------------------

### `knockd_sequence`
Definition that constructs a sequence to be specified in the knockd configuration. 

#### Actions
- :enable: adds sequence to configuration
- :disable: removes sequence from configuration

#### Attribute Parameters
- sequence: list of ports following the <port1>[:<tcp|udp>] syntax.
- port: alternative listing of ports.
- tcpflags: list of flags for tcp ports.  Defaults to [:syn,:ack]
- seq_timeout: sequence timeout.  Defaults to 30 seconds
- auto_close: if specified, causes on_close to be fired after N seconds.  Defaults to off value -1.
- on_open: command to run when port is opened.
- on_close: command to run when port is closed.  Only works with valid auto_close.

### `knockd_client`
Performs a simple knock.  Does this at the start of the resource section.

#### Actions
- :enable: performs knock sequence.
- :nothing: does nothing.

#### Attribute Parameters
- ip: Destination IP address.
- sequence: list of ports following the <port1>[:<tcp|udp>] syntax.


License & Authors
-----------------
- Author:: Ted Chen (<ted@nephilagraphic.com>)

```text
Copyright 2014, Nephila Graphic

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
