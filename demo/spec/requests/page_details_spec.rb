require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a page_detail exists" do
  request(resource(:page_details), :method => "POST", 
    :params => { :page_detail => {  }})
end

describe "resource(:page_details)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:page_details))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of speakers" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a page_detail exists" do
    before(:each) do
      @response = request(resource(:page_details))
    end
    
    it "has a list of page_details" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      @response = request(resource(:page_details), :method => "POST", 
        :params => { :page_detail => {  }})
    end
    
    it "redirects to resource(:page_details)" do
    end
    
  end
end

