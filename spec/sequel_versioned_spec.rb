require File.join(File.dirname(__FILE__), "spec_helper")

describe "Sequel Verioned Plugin" do

  before(:all) do
    @fact = Fact.create
  end

  it "should have a dimension created" do
    @fact.current_dimension.should_not be_nil
  end

  it "should store collection objects" do
    2.times do
      @c = Collection.create
      @fact.add_collection(@c)
    end
    @fact.current_collections.include?(@c).should == true
  end
  
  it "should version dimension" do
    old_version_dimension = @fact.current_dimension
    @fact.version!
    @fact.current_dimension.version.should == old_version_dimension.version + 1
  end
  
  it "should fetch an arbitary version" do
    @fact.fetch_version = 0
    @fact.current_dimension.version.should == 0
    @fact.current_collections.first.version.should == 0
    @fact.fetch_version = nil
  end
  
  it "should version collections" do
    old_version_collections = @fact.current_collections
    @fact.version!
    @fact.current_collections.first.version.should == old_version_collections.first.version + 1
    @fact.current_collections.size.should == old_version_collections.size
  end
  
  it "should handle attribute delegation" do
    d = @fact.current_dimension
    d.name = "foo"
    d.save
    @fact.name.should == "foo"
  end
  
end
