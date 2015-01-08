#
# Cookbook Name:: knockd
# Definition:: sequence
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

define :knockd_sequence, sequence: [],
                         tcpflags: [:syn, :ack],
                         seq_timeout: 30,
                         auto_close: -1,
                         on_open: '',
                         on_close: '' do
  # Validate sequence
  fail Chef::Exceptions::ValidationFailed,
    'sequence should contain port definitions matchin <port1>[:<tcp|udp>]' unless KnockdValidator.validate_ports(params[:sequence])

  # Validate sequence
  fail Chef::Exceptions::ValidationFailed,
    'tcpflags should contain a valid tcp flag type' unless KnockdValidator.validate_tcpflags(params[:tcpflags])

  block = []
  block << "sequence = #{params[:sequence].flatten.join(',') }"
  block << "seq_timeout = #{params[:seq_timeout]}"
  block << "tcpflags = #{Array(params[:tcpflags]).flatten.join(',') }"

  if params[:auto_close] >= 0
    block << "start_command = #{params[:on_open]}"
    block << "cmd_timeout = #{params[:auto_close]}"
    block << "stop_command = #{params[:on_close]}"
  else
    block << "command = #{params[:on_open]}"
  end

  t = begin
    resources(template: '/etc/knockd.conf')
  rescue Chef::Exceptions::ResourceNotFound
    template '/etc/knockd.conf' do
      source 'knockd.conf.erb'
      cookbook 'knockd'
      mode 00640
      variables(
        blocks: {}
      )
      notifies :restart, 'service[knockd]'
    end
  end

  t.variables[:blocks][params[:name]] = block
end
