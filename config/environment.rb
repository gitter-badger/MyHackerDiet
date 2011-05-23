# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Mhd::Application.initialize!


RECTYPE = Hash.new
RECTYPE['withings'] = 0
RECTYPE['manual']   = 1
RECTYPE['filler']   = 2
