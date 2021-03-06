# -*- coding:binary -*-

require 'spec_helper'
require 'msf/core/option_container'

describe Msf::OptAddressRange do
  # Normalized values are just the original value for OptAddressRange
  valid_values = [
    { :value => "192.0.2.0/24",    :normalized => "192.0.2.0/24" },
    { :value => "192.0.2.0-255",   :normalized => "192.0.2.0-255" },
    { :value => "192.0.2.0,1-255", :normalized => "192.0.2.0,1-255" },
    { :value => "192.0.2.*",       :normalized => "192.0.2.*" },
    { :value => "192.0.2.0-192.0.2.255", :normalized => "192.0.2.0-192.0.2.255" }
  ]
  invalid_values = [
    # Too many dots
    { :value => "192.0.2.0.0" },
    { :value => "192.0.2.0.0,1" },
    { :value => "192.0.2.0.0,1-2" },
    { :value => "192.0.2.0.0/24" },
    # Not enough dots
    { :value => "192.0.2" },
    { :value => "192.0.2,1" },
    { :value => "192.0.2,1-2" },
    { :value => "192.0.2/24" },
    # Can't mix ranges and CIDR
    { :value => "192.0.2.0,1/24" },
    { :value => "192.0.2.0-1/24" },
    { :value => "192.0.2.0,1-2/24" },
    { :value => "192.0.2.0/1-24" },
    { :value => "192.0.2.0-192.0.2.1-255" },
    # Non-string values
    { :value => true},
    { :value => 5 },
    { :value => []},
    { :value => [1,2]},
    { :value => {}},
  ]

  it_behaves_like "an option", valid_values, invalid_values, 'addressrange'

  let(:required_opt) {  Msf::OptAddressRange.new('RHOSTS', [true, 'The target addresses', '']) }

  context 'the normalizer' do
    it 'should handle a call for random IPs' do
      random_addresses = required_opt.normalize('rand:5')
      random_addresses.kind_of?(String).should == true
      ips = random_addresses.split(' ')
      ips.count.should == 5
      ips.each do |ip|
        (ip =~ Rex::Socket::MATCH_IPV4).should == 0
      end
    end
  end

end


