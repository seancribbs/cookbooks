#
# Author:: Benjamin Black (<b@b3k.us>) and Sean Cribbs (<sean@basho.com>)
# Cookbook Name:: riak
# Recipe:: autoconf
#
# Copyright (c) 2010 Basho Technologies, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "riak::default"

bin_paths = if node[:riak][:package][:type] == "binary"
              ["/usr/sbin"]
            else
              ["#{node[:riak][:package][:prefix]}/riak/bin"]
            end

execute "Wait for Riak to start" do
  command "riak-admin wait-for-service riak_kv #{node[:riak][:erlang][:node_name]}"
  path bin_paths
  user 'riak'
  timeout 30
end

riak_cluster node[:riak][:core][:cluster_name] do
  node_name node[:riak][:erlang][:node_name]
  action :join
  riak_admin_path bin_paths.first
end
