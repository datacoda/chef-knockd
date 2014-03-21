#
# Cookbook Name:: knockd
# Provider:: default
#
# Copyright (C) 2014 Nephila Graphic
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#



action :disable do
  r = service 'knockd' do
    action :stop
    enabled false
  end

  template '/etc/default/knockd' do
    source      'knockd'
    cookbook    'default.knocked.erb'
    mode        00640
    variables(
        :enabled => false,
        :interface => new_resource.interface
    )
  end

  new_resource.updated_by_last_action(r.updated_by_last_action)
end



action :enable do
  r = service 'knockd' do
    action :enable
    enabled true
    supports [:start, :restart, :stop]
  end

  t1 = template '/etc/knockd.conf' do
    source      'knockd.conf.erb'
    cookbook    'knockd'
    mode        00640
    variables(
        :blocks => KnockdConfig.instance.blocks
    )
  end

  t1.run_action(:create)

  t2 = template '/etc/default/knockd' do
    source      'default.knockd.erb'
    cookbook    'knockd'
    mode        00644
    variables(
        :enabled => true,
        :interface => new_resource.interface
    )
    notifies  :restart, 'service[knockd]'
  end

  t2.run_action(:create)

  # note: required here since notify does not work inside run_action
  changed = t1.updated_by_last_action? || t2.updated_by_last_action?

  if changed
    r.run_action(:restart)
  end

  new_resource.updated_by_last_action(changed)
end
