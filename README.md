# TASK

Using your favorite language, create a script which uses AWS API access
to list all EC2 instances in any single region, sorted by the value of a tag
each instance has called ‘Owner’.  The script should display the results in an
easy to read format which includes the instance id, tag value, instance type
and launch time.  The script should work for any number of instances, and
should display any instances without an Owner tag as type 'unknown' with the
instance id, type and launch time.  Design the script so it could be used
later to find tags with other names and output additional instance information
by request. 

# Here goes...

It's been a long time since I wrote anything in ruby for a stand alone script.
Maybe 8 years.  I've tried to follow what is considered good practices even
though my command of the language is pretty poor at this point.  So, I suppose,
I'm asking you to consider what I could get done on 5 hours of knowledge
refresh... ;-)

# usage
```
ruby bin/ec2_list.rb -h

Usage: ec2_list.rb [options]
    -r, --region REGION              which region to look in ( default: us-west-2 )
    -d, --debug                      Debug ( spits out AWS dump )
    -v, --[no-]verbose               Run verbosely
    -t, --tag TAG                    Looking for specific tag ( default: Owner )
```
