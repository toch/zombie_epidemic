# encoding: UTF-8
gem 'minitest' # demand gem version
require 'minitest/autorun'
require 'turn/autorun'

$LOAD_PATH << File.expand_path('../lib', File.dirname(__FILE__))
require_relative '../lib/zombies'