# encoding: utf-8

require 'rubygems'
require(File.expand_path('../lib/version.rb',__FILE__))

Gem::Specification.new do |s|
  s.name        = 'kernel32lib'
  s.version     = Kernel32Lib::VERSION
  s.licenses    = ['MIT']
  s.summary     = 'kernel32lib lib'
  s.description = 'Win32 API wrapper for Ruby which uses Fiddle and Fiddle::Importer.'
  s.authors     = ['first name last name']
  s.email       = ['name@server.domain']
  s.homepage    = 'http://server.domain/kernel32lib'
  s.platform = Gem::Platform::RUBY
  s.files       = Dir['*.md']+Dir['kernel32lib.*']+Dir['lib/*.rb']+Dir['win_api/*.rb']+Dir['test/*.rb']+Dir['fixtures/*']
  s.require_path = 'lib'
end
