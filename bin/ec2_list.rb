#!/usr/bin/env ruby

# pull in aws lib
# get a list of all instances for a region option 
# find out all information on instance
# pull out the tags, type, and lauch time
# look for the option tag, 
# if no option tag 
# then call it unknown
# display the instance id, type, lauch time, and option tag 
# pretty page results



require 'rubygems'
require 'aws-sdk'
require 'optparse'
require 'pp'

#############################
## Option parsing
#############################
options = OpenStruct.new

# some defaults
options.region = "us-west-2"
options.debug = false
options.verbose = false
options.tag = "Owner"

opt_parser = OptionParser.new do |opts|

  opts.banner = "Usage: ec2_list.rb [options]"


  opts.on("-r", "--region REGION", "which region to look in ( default: us-west-2 )") do |r|

    options[:region] = r

  end

  # will dump out the aws response in case you're trying to find something to add.
  opts.on("-d", "--debug", "Debug ( spits out AWS dump )") do |d|

    options[:debug] = d

  end

  # will basically dump out the all the tags or whatever is added to verbose later.
  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|

    options[:verbose] = v

  end

  # you can look for other tags...
  opts.on("-t", "--tag TAG", "Looking for specific tag ( default: Owner )") do |t|

    options[:tag] = t

  end

end

# handle the lack of args or opts
begin opt_parser.parse! ARGV
rescue OptionParser::InvalidOption, OptionParser::MissingArgument
  puts $!.to_s
  puts opt_parser
  exit 1
end


# region has a default set, you can override that.
# credentials are assumed to be in your ~/.aws/credentials or some such

ec2_client = Aws::EC2::Client.new( region: options.region )
resp = ec2_client.describe_instances 

# dump instance if you're looking for a needle in a haystack
if options[:debug]

  pp resp

end

#############################
## EC2 instances Info
#############################
out = nil

# you might not get anything back
if resp.reservations.any?

  # for each response record
  resp.each do | inst |

    # grab the instance info
    inst.reservations.each do | reserv |

      # as far as i can tell there is only one instance per
      instance = reserv.instances[0]

      puts "============================"
      puts "Instance ID:\t#{instance.instance_id}"
      puts "Instance Type\t#{instance.instance_type}"
      puts "Launch Time:\t#{instance.launch_time}"

      specific_tag = nil

      # looking for existance of the Owner tag
      instance.tags.each do | t |

        if t.key == options.tag

          specific_tag=t.value

        elsif options[:verbose]

          # puts all tags
          puts "Tag:\t#{t.key}=#{t.value}"

        end

      end

      if specific_tag

        puts "Tag:\t#{options.tag}=#{specific_tag}"

      else

        puts "Tag:\t#{options.tag}=unknown"

      end

    end

  end

else

  puts "Nothing found in #{options.region}."

end
