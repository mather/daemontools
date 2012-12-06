#
# Cookbook Name:: daemontools
# Recipe:: source
#
# Copyright 2010-2012, Opscode, Inc.
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

include_recipe "build-essential"

#
# Skip if installed
#
unless ::File.exists?("#{node['daemontools']['bin_dir']}/svscan")

  remote_file "/tmp/daemontools-0.76.tar.gz" do
    source "http://cr.yp.to/daemontools/daemontools-0.76.tar.gz"
    owner "root"
    mode "0644"
  end

  bash "Compile daemontools" do
    user "root"
    cwd "/tmp"
    code <<-EOH
      tar zxvf daemontools-0.76.tar.gz
      cd admin/daemontools-0.76
      perl -pi -e 's/extern int errno;/\#include <errno.h>/' src/error.h
      package/compile
    EOH
  end

  template "/tmp/admin/daemontools-0.76/package/upgrade" do
    source "package/upgrade.erb"
    mode "0755"
  end
  template "/tmp/admin/daemontools-0.76/package/run" do
    source "package/run.erb"
    mode "0755"
  end

  bash "Install daemontools" do
    user "root"
    cwd "/tmp/admin/daemontools-0.76"
    code <<-EOH
      package/upgrade
      package/run
    EOH
  end

end
