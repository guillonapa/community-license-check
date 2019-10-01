require "rexml/document"

include REXML

class POMLicenseCheck

    # arg should be the root directory containing the first pom.xml file
    def initialize argv
        if (argv.kind_of? Array)
            if (argv.length != 1)
                puts "Error: wrong number of arguments in array for 'pom_license_check' script (given " << ARGV.length.to_s << ", expected 1)"
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

    def stringunify name, url, distribution
        return "[#{name}, #{url}, #{distribution}]"
    end

    # will use module declarations in poms and check for licenses in each one
    def traverse_project_and_check root
        initial_path = String.new root
        if !initial_path.end_with? "/"
            initial_path << "/"
        end
        puts "Validating license node in pom.xml for #{initial_path}"
        pom_path = "#{initial_path}pom.xml"
        check_pom pom_path
        pom_file = File.new(pom_path)
        pom_xml = Document.new(pom_file)

        xml_root = pom_xml.root

        xml_root.elements.each("modules/module") do |mvn_module|
            traverse_project_and_check "#{initial_path}#{mvn_module.get_text}"
        end
    end
    
    # checks for valid license group in pom.xml
    def check_pom pom_path
        xmlFile = File.new(pom_path)
        
        xmlDoc = Document.new(xmlFile)
        
        root = xmlDoc.root

        # check for studio property
        is_studio_sample = false
        root.elements.each("properties/com.tibco.ep.sb.studio.sample") do |property|
            is_studio_sample = property.get_text.to_s.downcase == "true"
        end
        
        # will return only the first license encountered
        root.elements.each("licenses/license") do |license|
            # <license>
            #     <name>BSD 3-Clause License</name>
            #     <url>https://raw.githubusercontent.com/TIBCOSoftware/tibco-streaming-community/master/docs/Components-LICENSE</url>
            #     <distribution>repo</distribution>
            # </license>
            lic_name = lic_url = lic_distrib = nil
            license.elements.each("name") { |name| lic_name = name.get_text }
            license.elements.each("url") { |url| lic_url = url.get_text }
            license.elements.each("distribution") { |distribution| lic_distrib = distribution.get_text }

            if lic_name != "BSD 3-Clause License" || lic_url != "https://raw.githubusercontent.com/TIBCOSoftware/tibco-streaming-community/master/docs/Components-LICENSE" || lic_distrib != "repo"
                raise "Error: A BSD-3-clause license is required for #{pom_path} (found #{stringunify lic_name, lic_url, lic_distrib}, expected #{stringunify "BSD 3-Clause License", "https://raw.githubusercontent.com/TIBCOSoftware/tibco-streaming-community/master/docs/Components-LICENSE", "repo"}"
            end
            return true
        end

        # studio samples MUST include the right license in the pom
        if is_studio_sample
            raise "Error: A license must be declared in #{pom_path}"
        end
        return true
    end

    # check for licenses in the whole project (pom.xml files only)
    def check
        traverse_project_and_check @proj_root
    end
    
end