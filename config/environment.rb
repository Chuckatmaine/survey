# Load the rails application
require File.expand_path('../application', __FILE__)
require 'casclient'
require 'casclient/frameworks/rails/filter'

CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "https://identity.maine.edu/cas"
)

    #hack to get csv working in both 1.9 and 1.8
    if RUBY_VERSION > "1.9"    
      require "csv"  
      unless defined? FCSV
        class Object  
          FCSV = CSV 
          alias_method :FCSV, :CSV
        end  
      end
    end   

# Initialize the rails application
SurveyApp::Application.initialize!
