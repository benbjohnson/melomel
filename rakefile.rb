require 'sprout'
require 'sprout/flex4sdk/version'
#Comment out the above and uncomment the next line in order to use the flex3sdk
#require 'sprout/flex3sdk/version'

# Load gems from a server other than rubyforge:
sprout 'as3'

gem_wrap :make_melomel_gem do |t|
  t.gem_name = 'sprout-melomel-library'
  t.author = 'Nikita Dudnik'
  t.email = 'nikdudnik@gmail.com'
  t.homepage = "http://melomel.info"
  t.version = '0.6.1'
  # t.description = "This gem provides a compiled swc file of Melomel (http://melomel.info) to use with project Sprouts (http://projectsprouts.org).
  # 
  # Melomel is an API for accessing ActionScript objects in the Flash virtual machine through external languages. This is especially useful for integrating Flash into a full stack functional testing solution such as Cucumber or RSpec."
  t.summary = "Melomel is an API for accessing ActionScript objects in the Flash virtual machine through external languages."
  t.sprout_spec   = "
    - !ruby/object:Sprout::RemoteFileTarget
      platform: universal
      url: http://github.com/downloads/benbjohnson/melomel/melomel-0.6.1.zip
      archive_path: melomel-0.6.1.swc
    "
end 

gem_wrap :make_melomel_stub_gem do |t|
  t.gem_name = 'sprout-melomel_stub-library'
  t.author = 'Nikita Dudnik'
  t.email = 'nikdudnik@gmail.com'
  t.homepage = "http://melomel.info"
  t.version = '0.6.1'
  t.summary = "Stub of Melomel library (see melomel-sprout-library gem). Melomel is an API for accessing ActionScript objects in the Flash virtual machine through external languages."
  # t.description = "This gem provides a compiled stub swc file of Melomel (http://melomel.info) to use with project Sprouts (http://projectsprouts.org).
  # 
  # Melomel is an API for accessing ActionScript objects in the Flash virtual machine through external languages. This is especially useful for integrating Flash into a full stack functional testing solution such as Cucumber or RSpec."
  t.sprout_spec   = "
    - !ruby/object:Sprout::RemoteFileTarget
      platform: universal
      url: http://github.com/downloads/benbjohnson/melomel/melomel-0.6.1.zip
      archive_path: melomel-stub-0.6.1.swc
    "
end

task :default => [:make_melomel_gem, :make_melomel_stub_gem]