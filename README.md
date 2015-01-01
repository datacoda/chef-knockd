knockd cookbook
---------------
Provides LWRP for knockd


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

Include the `knockd::default` recipe to start using the LWRPs.

```ruby
include_recipe 'knockd'

knockd 'knockknock' do
  action    :nothing
  supports [:enable, :disable]
end

knockd_sequence 'openHTTP' do
  port '7000'
  port '8000'
  port '9000'
  tcpflags :syn
  on_open '/sbin/iptables -A INPUT -s %IP% -p tcp --dport 80 -j ACCEPT'

  notifies  :enable, 'knockd[knockknock]'
end

knockd_sequence 'https' do
  sequence [ '2123', '2124:tcp', '2125:udp' ]
  tcpflags [ :syn, :ack ]
  on_open 'echo https open'
  notifies  :enable, 'knockd[knockknock]'
end
```


Attributes
----------

- `['knockd']['interface']` - Make knockd listen to a specific interface.  default nil.


Recipes
-------

### default
Provides LWRP for knockd.  Note that by default, knockd service is disabled.


Resources/Providers
-------------------

### `knockd`
This LWRP creates the primary service configuration.

#### Actions
- :enable: turns on knockd
- :disable: turns off knockd

#### Attribute Parameters
- interface: Listen to specific interface.  Defaults to node['knockd']['interface'] value.


### `knockd_sequence`
Each sequence gets its own resource.

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