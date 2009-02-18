require File.join(File.dirname(__FILE__), "spec_helper")

describe "Sequel Verioned Plugin" do

  before(:all) do
    @fact = Fact.create
  end

  it "should have a dimension created" do
    @fact.fetch_dimension.should_not be_nil
  end

  it "should store collection objects" do
    2.times do
      @c = Collection.create
      @fact.add_collection(@c)
    end
    @fact.fetch_collections.include?(@c).should == true
  end
  
  it "should version dimension" do
    old_version_dimension = @fact.fetch_dimension
    @fact.version!
    @fact.fetch_dimension.version.should == old_version_dimension.version + 1
  end
  
  it "should fetch an arbitary version" do
    @fact.fetch_version = 0
    @fact.fetch_dimension.version.should == 0
    @fact.fetch_collections.first.version.should == 0
    @fact.fetch_version = nil
  end
  
  it "should version collections" do
    old_version_collections = @fact.fetch_collections
    @fact.version!
    @fact.fetch_collections.first.version.should == old_version_collections.first.version + 1
    @fact.fetch_collections.size.should == old_version_collections.size
  end
  
  it "should save the correct version number on dimensions" do
    @fact.version!
    @fact.dimension_version.should == @fact.fetch_dimension.version
  end
  
  it "should handle attribute delegation" do
    d = @fact.fetch_dimension
    d.name = "foo"
    d.save
    @fact.name.should == "foo"
  end
  
  it "should be able to update a older version of dimenions and not effect current one" do
    @fact = Fact.create
    d = @fact.fetch_dimension
    d.name = "editing old"
    d.save
    @fact.version!
    #v1
    d = @fact.fetch_dimension
    d.name = "editing old again"
    d.save
    @fact.version!
    #v2
    
    @fact.fetch_version = 0
    d = @fact.fetch_dimension
    d.name = "editing back in time"
    d.save
    @fact.fetch_dimension.name.should == "editing back in time"
    
    @fact.latest
    @fact.fetch_dimension.name.should == "editing old again"
  end
  
end
