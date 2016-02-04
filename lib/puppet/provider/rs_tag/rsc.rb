# License
#
# Copyright 2014 Nextdoor.com, Inc.
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
#
# Author: Nathan Valentine <nathan@nextdoor.com|nrvale0@gmail.com>
# - Some code is lifted from rs_tag.rb.
#

require 'rubygems'
require 'json'

require_relative '../../../puppet_x/rightscale/utils.rb'

Puppet::Type.type(:rs_tag).provide(:rsc) do
  desc "Manage RightScale tags for a server"

  confine :is_rightscale => true, :rightlink_maj_version => 10
  defaultfor :rightlink_maj_version => 10

  commands :rsc => 'rsc'

  mk_resource_methods

  # Fetch all of our tags and pre-populate resource objects for each one
  # so that puppet knows which tags are already set.
  def self.get_tags()
    tag_properties = {}

    #    rightlink_self_href = Facter.value(:rightlink_self_href)
    rightlink_self_href = Facter.value(:rightlink_self_href)
    query_cmd = %W(--rl10 cm15 by_resource /api/tags/by_resource
                   resource_hrefs[]=#{rightlink_self_href})

    begin
      Puppet.debug("rs_tag:: command: rsc %s" % query_cmd)
      output = rsc(query_cmd)
#      puts "\nrsc output: #{output}"
      json_output = JSON.parse(output)
#      puts "\njson_output: #{json_output}"
      tags = json_output[0]['tags']
#      puts "\ntags: #{tags}"
#      tags = JSON.parse(rsc(query_cmd))[0]['tags']
    rescue Puppet::ExecutionFailure, JSON::ParserError => e
      Puppet.debug("Rs_tag execution had an error -> #{e.inspect}")
      return nil
    end
    
    Puppet.debug("rs_tag::rsc :: tags: #{tags}")
    
    # Dump all the tags into a hash
    providers = []
    tags.each do |tag|
      # Create a new fresh properties hash
      properties = {}

      # Split our tag into a name/value
      k, v = tag['name'].split('=', 2)
      Puppet::debug("Rs_tag::rsc::get_tags: k: #{k}, v: #{v}")

      # Now populate some instance properties about the state of this tag
      properties[:ensure]   = :present
      properties[:value]    = v
      properties[:provider] = :rsc
      properties[:name]     = k

      Puppet.debug("Tag properties: #{properties.inspect}")
      providers << new(properties)
    end
    providers
  end

  
  def self.instances
    self.get_tags()
  end

  
  def self.prefetch(resources)
    i = instances
    return nil if not i

    i.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end


  def exists?
    @property_hash[:ensure] == :present
  end

  
  def create
    rightlink_self_href = Facter.value(:rightlink_self_href)
    add_cmd = %W(--rl10 cm15 multi_add /api/tags/multi_add
                 resource_hrefs[]=#{rightlink_self_href})
    tag = PuppetX::RightScale::Utils.generate_tag(resource[:name], resource[:value])
    Puppet.debug("Create tag: #{tag}")
    rsc(add_cmd << "tags[]=#{tag}")
  end

  
  def destroy
    rightlink_self_href = Facter.value(:rightlink_self_href)
    delete_cmd = %W(--rl10 cm15 multi_delete /api/tags/multi_delete
                    resource_hrefs[]=#{rightlink_self_href})

    # rsc is a little weird in that it needs both the name and value of a tag
    # to pass to the RS API. To delete a tag we need to compose a tag from
    # resource[:name] and @property_hash[:value]
    tag = PuppetX::RightScale::Utils.generate_tag(resource[:name], @property_hash[:value])
    Puppet.debug("Destroy tag: #{tag}")
    rsc(delete_cmd << "tags[]=#{tag}")
  end

  
  # Updating the 'value' of a tag is no different than creating a new tag,
  # so we just call the create() method.
  def value=(value)
    create()
  end
end
