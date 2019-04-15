require 'optparse'
require 'ostruct'

class Options
    def self.parse args
        get_options args
    end

    def self.get_options args, destructive = false
        options = OpenStruct.new

        parser = OptionParser.new do |opts|
            opts.banner = "API Fuzz"

            opts.separator "Fuzz your API with bad strings."
            opts.separator ""

            opts.separator "Control options:"

            opts.on "-t", "--target PATH", "Example Url to fuzz with params" do |path|
                options[:target] = path
            end
        end

        parser.parse!(args)

        return options
    end
end