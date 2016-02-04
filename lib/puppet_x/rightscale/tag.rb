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

require_relative './utils.rb'

module PuppetX
  module RightScale
    module Tag

      def create_properties_and_params
        
        ensurable do
          defaultvalues
          defaultto :present
        end

        
        newparam(:name, :namevar => true) do
          validate do |name|
            PuppetX::RightScale::Utils.validate_tag({:name => name})
          end
        end

        
        newproperty(:value) do
          validate do |value|
            PuppetX::RightScale::Utils.validate_tag({:value => value})
          end
        end

        
        validate do
          Puppet.debug("Validating the entire Rs_tag Type....")

          # It's quite tricky to check that 'value =>' exists for Machine Tags
          # in the various scenarios involving both resource queries and enforcements
          # but I believe this covers *most* of the bases.

          Puppet.debug("self:: #{self.to_hash}")
#          Puppet.debug("self.provider.value:: #{self.provider.value}")
          
          tag_type = PuppetX::RightScale::Utils.validate_tag({:name => self[:name]})

          case tag_type
          when 'Machine'
            # Name check validated. What about the required 'value =>' in the current mode?
            fail("self.provider does not exist?!? Should never get here!") unless self.provider

            # query operation request
            if nil == self[:ensure]
              Puppet.debug("Detected Rs_tag resource query...")
              fail("Queried Rs_tag Machine Tag does not have both name and value!") unless
                self.provider.name and self.provider.value # not that valid .value is :absent

            # delete operation request or absent result
            elsif :absent == self[:ensure]
              Puppet.debug("Detected Rs_tag delete operation of absent tag...")
     
            # create operation request or successful query operation
            # Note: Machine Tags require specified property 'value'. Raw tags do not.
            elsif :present == self[:ensure]
              
              # I think this is a create operation because the provider has nothing for a
              # queried value and yet we are :ensure => present.
              if :absent == self.provider.value
                fail("Machine Tag \'#{self[:name]}\' must specify a \'value\'.") unless
                  nil != self[:value]
                return true
              end
            end

          when 'Raw'
            fail("Raw Tags cannot have a specified \'value\'!") unless nil == self[:value]
            
          when 'Unvalidated'
            fail("Unvalidated Rs_tag name/type! Should never get here!")
          end
            
        end
      end
    end
  end
end

          
