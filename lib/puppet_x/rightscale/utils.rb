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

module PuppetX
  module RightScale
    module Utils


      def self.validate_tag(options = {})

        n_p_sep = '\:'
        k_v_sep = '='

        namespace_re = '([a-z]{1}[a-z0-9_]+)'
        predicate_re = '([a-zA-Z]{1}[a-zA-Z0-9_]+)'
        value_re = '([a-zA-Z\S\t ]+)' # any non-whitespace + tab or space but no newline

        raw_tag_re = '^([a-z0-9_]+)$'
        machine_tag_key_re = "(#{namespace_re}#{n_p_sep}#{predicate_re})"
        machine_tag_re = "^(#{machine_tag_key_re}#{k_v_sep}#{value_re})$"

        
        # If caller requested validation of name...
        tag_type = 'Unvalidated'
        if nil != options[:name]
          if options[:name] =~ Regexp.new(machine_tag_key_re)
            tag_type = 'Machine'
          elsif options[:name] =~ Regexp.new(raw_tag_re)
            tag_type = 'Raw'
          else
            fail("Tag \'#{options[:name]}\' validates as neither Machine Tag nor Raw Tag.")
          end
        
          Puppet.debug("Tag \'#{options[:name]}\' validates as #{tag_type} Tag.")
        end


        # If caller requested validation of value...
        if nil != options[:value]
          if 'Unvalidated' == tag_type
            Puppet.debug("Tag name \'#{options[:name]}\' unvalidated per user request.")
            
          elsif 'Raw' == tag_type
            fail("Raw Tags cannot have a specified value per the RightScale Tag spec.")

          elsif options[:value] !~ Regexp.new(value_re)
            fail(
              "Tag \'#{options[:name]}\' => \'#{options[:value]}\' " \
              "value does not pass \'#{value_re}\' validation.")
            Pupppet.debug("Tag value \'#{options[:value]}\' validates.")
          end
        end
        
        tag_type
      end

      
      def self.generate_tag(name, value)
        case validate_tag({:name => name, :value => value})
        when 'Machine'
          return "#{name}=#{value}"
        when 'Raw'
          return name
        else
          fail("Tag type is neither Machine nor Raw. Should never get here!")
        end
      end
      
    end
  end
end
