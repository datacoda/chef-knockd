#
# Cookbook Name:: knockd
# Resource:: sequence
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

actions :enable, :disable

attribute :name, kind_of: String, name_attribute: true
attribute :sequence, kind_of: Array, required: true, callbacks: {
  'should contain port definitions matchin <port1>[:<tcp|udp>]' => lambda do
    |ports| Chef::Resource::KnockdSequence.validate_ports(ports)
  end
}
attribute :tcpflags, kind_of: [Array, Symbol], default: [:syn, :ack], callbacks: {
  'should contain a valid tcp flag type' => lambda do
    |flags| Chef::Resource::KnockdSequence.validate_tcpflags(flags)
  end
}
attribute :seq_timeout, kind_of: Integer, default: 30
attribute :auto_close, kind_of: Integer, default: -1
attribute :on_open, kind_of: String, required: true
attribute :on_close, kind_of: String

def initialize(name, run_context = nil)
  super
  if node['knockd'].attribute? name
    @sequence = node['knockd'][name]['sequence']
  else
    @sequence = []
  end
  @action = :enable
end

def port(rule)
  validate({ rule: rule }, rule: { kind_of: String, regex: VALID_PORT_REGEX })
  @sequence << rule
end

private

VALID_TCPFLAGS = [:fin, :syn, :rst, :psh, :ack, :urg]
VALID_PORT_REGEX = /^[0-9]+(:(udp|tcp))?$/

def self.validate_ports(ports)
  ports.reject { |port| ! (VALID_PORT_REGEX =~ port).nil? }.empty?
end

def self.validate_tcpflags(flags)
  Array(flags).reject { |key| VALID_TCPFLAGS.include?(key.to_sym) }.empty?
end
