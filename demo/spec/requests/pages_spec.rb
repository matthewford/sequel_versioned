require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a page exists" do
  request(resource(:pages), :method => "POST", 
    :params => { :page => {  }})
end

describe "resource(:pages)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:pages))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of speakers" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a page exists" do
    before(:each) do
      @response = request(resource(:pages))
    end
    
    it "has a list of pages" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      @response = request(resource(:pages), :method => "POST", 
        :params => { :page => {  }})
    end
    
    it "redirects to resource(:pages)" do
    end
    
  end
end

