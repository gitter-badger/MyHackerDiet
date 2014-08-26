# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

RECTYPE = Hash.new
RECTYPE['withings'] = 0
RECTYPE['manual']   = 1
RECTYPE['filler']   = 2
