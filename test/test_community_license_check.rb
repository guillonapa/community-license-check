require 'minitest/autorun'
require_relative '../lib/community_license_check'
require_relative '../lib/pom_license_check'

describe CommunityLicenseCheck do
    describe 'testing for correct licenses' do
        puts "Running tests for repository in location: " << File.expand_path(ARGV[0])

        describe 'verifying license files' do
            clc = CommunityLicenseCheck.new ARGV
            @results = clc.run
            @results.each do |key, license|
                it ' [' + key + ' must have a bsd-3-clause license]' do
                    _(license.key).must_equal "bsd-3-clause"
                end
            end
        end

        it 'must have valid license declarations in all pom.xml files' do
            puts ""
            pom_check = POMLicenseCheck.new ARGV
            pom_check.check
        end
    end
end
