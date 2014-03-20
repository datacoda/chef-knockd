#
# Cookbook Name:: knockd
# Provider:: sequence
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

require 'erb'



action :enable do
  block = ''
  block << "sequence = #{new_resource.sequence.flatten.join(',') }\n"
  block << "seq_timeout = #{new_resource.seq_timeout}\n"
  block << "tcpflags = #{new_resource.tcpflags.flatten.join(',') }\n"

  if new_resource.auto_close >= 0
    block << "start_command = #{new_resource.on_open}\n"
    block << "cmd_timeout = #{new_resource.auto_close}\n"
    block << "stop_command = #{new_resource.on_close}\n"
  else
    block << "command = #{new_resource.on_open}\n"
  end

  # write into singleton
  KnockdConfig.instance.addBlock(new_resource.name, block)
  new_resource.updated_by_last_action(true)
end

action :disable do
  new_resource.updated_by_last_action(true)
end
