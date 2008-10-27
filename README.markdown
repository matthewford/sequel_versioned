# Install
rake install

## Merb

In the before the app loads block add:

	dependency "sequel_versioned", "0.0.1" 

# Sequel Plugin

## Schema

The fact table needs for a versioned dimension both `dimension_id` and `dimension_version` attributes, the versioned dimension must have a `fact_id`.

For a versioned collection the fact table needs `collection_version`, and the collection objects must have a `fact_id`. 


## Model

The fact table needs to have a `many_to_one` association with each versioned dimension or collection.

To load the plugin in your Fact model
	
	is(:versioned_fact, {:collections => [Collection], :dimensions => [Dimension]})  
  

Then in your versioned models `is :versioned_dimension` or `is :versioned_collection` depending on what you need.

The method `version!` is available on the fact model, along with `current_dimension` and `current_collection`.

# Example

Say we have a blog posts and comments, all of which need to be versioned.
So `post` would be our fact table, with `post_detail` as it's dimension. Each post would also have a `versioned_collection` of comments.

    class Post < Sequel::Model
      set_schema do
        foreign_key :post_detail, :table => :post_details
      end
      
      is(:versioned_fact, {:collections => [Comment], :dimensions => [PostDetail]})  
      
      one_to_many :comments
      one_to_many :post_details
  
      def body
        current_post_detail.body
      end
    end
    
The Post table would have to have the following fields defined: `post_detail_id`, `post_detail_version`, `comments_version`.

So when a new post is created a corresponding `post_detail` is also created. 

To version the post and the comments, the method `version!` is provided on instances of the Post class.
    
    class PostDetail < Sequel::Model
     set_schema do
       foreign_key :post_id, :table => :posts
     end
     is :versioned_dimension
     many_to_one :post
    end

    class Comments < Sequel::Model
     set_schema do
     foreign_key :post_id, :table => :posts
     end
     is :versioned_collection
     many_to_one :post
    end
    
The `comments` and `post_details` table would have `post_id` and `version` defined.