require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a comment exists" do
  request(resource(:comments), :method => "POST", 
    :params => { :comment => {  }})
end

describe "resource(:comments)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:comments))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of speakers" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a comment exists" do
    before(:each) do
      @response = request(resource(:comments))
    end
    
    it "has a list of comments" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      @response = request(resource(:comments), :method => "POST", 
        :params => { :comment => {  }})
    end
    
    it "redirects to resource(:comments)" do
    end
    
  end
end

