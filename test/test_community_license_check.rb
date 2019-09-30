require 'minitest/autorun'
require_relative '../lib/community_license_check'

describe CommunityLicenseCheck do
    describe 'testing for correct licenses' do
        it 'must have a valid license in docs and valid individual licenses per component' do
            clc = CommunityLicenseCheck.new ARGV
            @results = clc.run
            @results.each do |key, license|
                _(license.key).must_equal "bsd-2-clause"
            end
        end
    end
end
