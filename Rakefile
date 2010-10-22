require 'sprout'
sprout 'as3'

module Melomel
  VERSION = IO.read('build.xml').match(/<property name="version" value="(.+?)"\/>/)[1]
end


#############################################################################
#
# Packaging tasks
#
#############################################################################

gem_wrap :build_melomel_gem do |t|
  t.gem_name = 'sprout-melomel-library'
  t.author = 'Nikita Dudnik'
  t.email = 'nikdudnik@gmail.com'
  t.homepage = "http://melomel.info"
  t.version = Melomel::VERSION
  t.package = 'target'
  t.summary = "Melomel: External ActionScript Interface. Use with project Sprouts."
  t.sprout_spec   = "
    - !ruby/object:Sprout::RemoteFileTarget
      platform: universal
      url: http://github.com/downloads/benbjohnson/melomel/melomel-#{Melomel::VERSION}.zip
      archive_path: melomel-#{Melomel::VERSION}.swc
    "
end 

gem_wrap :build_melomel_stub_gem do |t|
  t.gem_name = 'sprout-melomel_stub-library'
  t.author = 'Nikita Dudnik'
  t.email = 'nikdudnik@gmail.com'
  t.homepage = "http://melomel.info"
  t.version = Melomel::VERSION
  t.package = 'target'
  t.summary = "Stub of the the Melomel library. Use with project Sprouts."
  t.sprout_spec   = "
    - !ruby/object:Sprout::RemoteFileTarget
      platform: universal
      url: http://github.com/downloads/benbjohnson/melomel/melomel-#{Melomel::VERSION}.zip
      archive_path: melomel-stub-#{Melomel::VERSION}.swc
    "
end

task :release do
  puts ""
  print "Are you sure you want to relase Melomel #{Melomel::VERSION}? [y/N] "
  exit unless STDIN.gets.index(/y/i) == 0
  
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  
  # Build melomel gem
  Rake::Task["build_melomel_gem"].invoke
  sh "gem push target/sprout-melomel-library-#{Melomel::VERSION}.gem"
  sh "rm target/sprout-melomel-#{Melomel::VERSION}.gem"
  
  # Build melomel stub gem
  Rake::Task["build_melomel_stub_gem"].invoke
  sh "gem push target/sprout-melomel_stub-library-#{Melomel::VERSION}.gem"
  sh "rm target/sprout-melomel_stub-library-#{Melomel::VERSION}.gem"
  
  # Commit
  sh "git commit --allow-empty -a -m 'v#{Melomel::VERSION}'"
  sh "git tag v#{Melomel::VERSION}"
  sh "git push origin master"
  sh "git push origin v#{Melomel::VERSION}"
end
