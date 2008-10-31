require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a wiki exists" do
  request(resource(:wikis), :method => "POST", 
    :params => { :wiki => {  }})
end

describe "resource(:wikis)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:wikis))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of speakers" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a wiki exists" do
    before(:each) do
      @response = request(resource(:wikis))
    end
    
    it "has a list of wikis" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      @response = request(resource(:wikis), :method => "POST", 
        :params => { :wiki => {  }})
    end
    
    it "redirects to resource(:wikis)" do
    end
    
  end
end

