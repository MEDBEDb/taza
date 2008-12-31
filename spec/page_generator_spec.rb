require 'spec/spec_helper'
require 'rubygems'
require 'fileutils'
require 'taza'

describe "Page Generation" do
  include RubiGen::GeneratorTestHelper
  include Helpers::Generator
  include Helpers::Taza

  before :all do
    @page_name = "CheckOut"
  end

  before :each do
    run_generator('taza', [APP_ROOT], generator_sources)
    @site_class = generate_site('Gap')
  end

  after :each do
    bare_teardown   
  end
  
  # Negative
  
  it "should give you usage if you provide no arguments" do
    lambda { run_generator('page', [], generator_sources) }.
      should raise_error(RubiGen::UsageError)
  end

  it "should give you usage if you provide two arguments" do
    lambda { run_generator('page', [@page_name, 'extra'], generator_sources) }.
      should raise_error(RubiGen::UsageError)
  end

  it "should display an error if no site is specified in the config.yml" do
    PageGenerator.any_instance.stubs(:site_name).returns(nil)
    lambda { run_generator('page', [@page_name], generator_sources) }.
      should raise_error(RubiGen::UsageError, "Error. A site must first be specified in config.yml")
  end

  it "should display an error if the site in config.yml can't be found" do
    PageGenerator.any_instance.stubs(:site_name).returns('no_such_site')
    lambda { run_generator('page', [@page_name], generator_sources) }.
      should raise_error(RubiGen::UsageError, /Error\. Site file .*lib\/no_such_site.rb not found\./)
  end
    


  # Positive

  it "should be able to access the generated page from the site" do
    PageGenerator.any_instance.stubs(:site_name).returns(@site_class.to_s)    
    run_generator('page', [@page_name], generator_sources)
    stub_settings
    stub_browser
    @site_class.new.check_out_page
  end

  it "should be able to generate a page when there is a site default" do
    PageGenerator.any_instance.stubs(:site_name).returns(@site_class.to_s)    
    lambda{run_generator('page', [@page_name], generator_sources)}.
      should_not raise_error
  end
    
end
