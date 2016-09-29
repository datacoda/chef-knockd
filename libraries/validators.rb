#
# Cookbook Name:: knockd
# Resource:: validators
#
# Copyright (C) 2016 Li-Te Chen
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

class KnockdValidator
  def self.validate_ports(ports)
    ports.reject do |port|
      port =~ /^[0-9]+(:(udp|tcp))?$/
    end.empty?
  end

  def self.validate_tcpflags(flags)
    tcpflags = [:fin, :syn, :rst, :psh, :ack, :urg]
    Array(flags).reject do |key|
      tcpflags.include?(key.to_sym)
    end.empty?
  end
end
