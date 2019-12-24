name 'knockd'
maintainer 'Li-Te Chen'
maintainer_email 'datacoda@gmail.com'
license 'Apache-2.0'
description 'Installs/Configures knockd'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.2.2'
chef_version '>=12'
source_url 'https://github.com/datacoda/chef-knockd'
issues_url 'https://github.com/datacoda/chef-knockd/issues'

%w[ubuntu debian].each do |os|
  supports os
end
