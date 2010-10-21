require 'sprout'
require 'sprout/flex4sdk/version'
sprout 'as3'

gem_wrap :make_melomel_gem do |t|
  t.gem_name = 'sprout-melomel-library'
  t.author = 'Nikita Dudnik'
  t.email = 'nikdudnik@gmail.com'
  t.homepage = "http://melomel.info"
  t.version = '0.6.1.1'
  t.summary = "Melomel: External ActionScript Interface. Use with project Sprouts."
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
  t.version = '0.6.1.1'
  t.summary = "Stub of the the Melomel library. Use with project Sprouts."
  t.sprout_spec   = "
    - !ruby/object:Sprout::RemoteFileTarget
      platform: universal
      url: http://github.com/downloads/benbjohnson/melomel/melomel-0.6.1.zip
      archive_path: melomel-stub-0.6.1.swc
    "
end

task :default => [:make_melomel_gem, :make_melomel_stub_gem]