require 'rubygems'
require 'bundler'
require 'set'
require 'net/http'
Bundler.require :default

require File.join(File.dirname(__FILE__), 'search_results_page')
require File.join(File.dirname(__FILE__), 'scraper')

scraper = Scraper.new
scraper.start
scraper.dump!
