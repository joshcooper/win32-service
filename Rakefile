require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rbconfig'
include Config

desc "Cleans up the C related files created during the build"
task :clean do
  Dir.chdir('ext') do
    if File.exists?('daemon.o') || File.exists?('daemon.so')
       sh 'nmake distclean'
    end
    File.delete('win32/daemon.so') if File.exists?('win32/daemon.so')
  end
end

desc "Builds, but does not install, the win32-service library"
task :build => [:clean] do
  Dir.chdir('ext') do
    ruby 'extconf.rb'
    sh 'nmake'
    FileUtils.cp('daemon.so', 'win32/daemon.so')      
  end  
end

desc "Install the win32-service library (non-gem)"
task :install => [:build] do
  Dir.chdir('ext') do
    sh 'nmake install'
  end
  install_dir = File.join(CONFIG['sitelibdir'], 'win32')
  Dir.mkdir(install_dir) unless File.exists?(install_dir)
  FileUtils.cp('lib/win32/service.rb', install_dir, :verbose => true)
end

desc 'Uninstall the (non-gem) win32-service library.'
task :uninstall do
  service = File.join(CONFIG['sitelibdir'], 'win32', 'service.rb')
  FileUtils.rm(service, :verbose => true) if File.exists?(service)

  daemon = File.join(CONFIG['sitearchdir'], 'win32', 'daemon.so')
  FileUtils.rm(daemon, :verbose => true) if File.exists?(daemon)
end

namespace 'gem' do
  desc 'Build the gem'
  task :build => [:clean] do
    spec = evan(IO.read('win32-open3.gemspec')) 
    Gem::Builder.new(spec).build
  end

  desc 'Install the gem'
  task :install => [:build] do
    file = Dir['*.gem'].first
    sh "gem install #{file}"
  end

  desc 'Build a binary gem'
  task :binary => [:build] do
    mkdir_p 'lib/win32'
    mv 'ext/win32/daemon.so', 'lib/win32/daemon.so'

    spec = eval(IO.read('win32-service.gemspec'))
    spec.extensions = nil
    spec.platform = Gem::Platform::CURRENT

    spec.files = spec.files.reject{ |f|
      f.include?('ext') || f.include?('git')
    }

    Gem::Builder.new(spec).build
  end
end

namespace 'test' do
  desc 'Run all tests for the win32-service library'
  Rake::TestTask.new('all') do |t|
    task :all => :build
    t.libs << 'ext'
    t.verbose = true
    t.warning = true
  end

  desc 'Run the tests for the Win32::Daemon class'
  Rake::TestTask.new('daemon') do |t|
    task :daemon => :build
    t.libs << 'ext'
    t.verbose = true
    t.warning = true
    t.test_files = FileList['test/test_win32_daemon.rb']
  end

  desc 'Run the tests for the Win32::Service class'
  Rake::TestTask.new('service') do |t|
    t.verbose = true
    t.warning = true
    t.test_files = FileList['test/test_win32_service.rb']
  end
end

task :test do
   Rake.application[:clean].execute
end

task :test_daemon do
   Rake.application[:clean].execute
end