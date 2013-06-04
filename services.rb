require 'rubygems'
require 'win32/service'

Win32::Service.services.map do |service|
  puts service.service_name
end
