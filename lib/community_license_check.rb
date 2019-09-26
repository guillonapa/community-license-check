require 'licensee'

class CommunityLicenseCheck

    # constructor
    def initialize argv
        if (argv.kind_of? Array)
            if (argv.length != 1)
                puts "Error: wrong number of arguments in array for 'community-license-check' script (given " << ARGV.length.to_s << ", expected 1)"
                exit(false)
            end
            @proj_root = argv[0]
            return
        elsif (!argv.kind_of? String)
            puts "Error: wrong kind of arguments (given " + argv.class + ", expected String or Array)"
            exit(false)
        end
        @proj_root = argv
    end
    
    # return { "docs/Components-LICENSE" => #<License>, "components/ams-client" => #<License>, ... }
    def run
        results_hash = Hash.new
        puts "Running check for repository in location: " << @proj_root
    
        # check for license in docs 'Components-LICENSE'
        docs = @proj_root + "/docs"
        puts "Looking for 'Components-LICENSE' in " << docs
        check_license(docs + "/Components-LICENSE", "docs/Components-LICENSE", results_hash)
    
        # check for each project in the components directory
        components = @proj_root + "/components"
        Dir.open components do |dir|
            dir.each do |file|
                component = components + "/" + file
    
                # skip dot directories (including '.' and '..')
                if (file.start_with? ".")
                    next
                end
    
                # check the license for each component
                if (File.directory? component)
                    puts "Looking for 'LICENSE' in " << component
                    check_license component, "components/" + file, results_hash
                end
            end
        end
        puts "DONE!"
        return results_hash
    end
    
    def check_license project_root_or_license_path, key, results_hash
        license = Licensee.license project_root_or_license_path
        results_hash[key] = license
    end
end
