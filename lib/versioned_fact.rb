module Sequel
  module Plugins
    # is(:versioned_fact, {:collections => [Dimension], :dimensions => [Collection]})
    #
    # provides: current_dimension, current_collections (dynamically)
    # 
    # Assumptions:
    # * there is one_to_many with a reciprocated many_to_one between fact and versioned objects
    # * used in conjenction with versioned object and/or collection
    module VersionedFact
      def self.apply(receiver, args={})
        receiver.class.class_eval do
          attr_accessor :dimensions
          attr_accessor :collections
        end
        receiver.dimensions = args[:dimensions]
        receiver.collections = args[:collections]

        # after create hooks for dimensions
        receiver.after_create do
          create_dimensions
        end
        
        #dynamic methods, current_dimension and current_collections
        #Instead of using module_eval, you could create an anonymous module to be included in receiver inside apply.
        string = ""
        unless receiver.dimensions.nil?
          receiver.dimensions.each do |dimension|
             method_name = "fetch_#{dimension.name.underscore}"
             string<<"def #{method_name};#{dimension}.fetch_for(self, fetch_version);end;"
          end
        end
        unless receiver.collections.nil?          
          receiver.collections.each do |collection|
            method_name = "fetch_#{collection.name.pluralize.underscore}"
            string<<"def #{method_name};#{collection}.fetch_for(self, fetch_version);end;"
          end
        end
         receiver.module_eval(string)
      end
      
      module InstanceMethods
        
        attr_accessor :fetch_version
        
        def create_dimensions
          self.class.dimensions.each do |dimension|
            d = dimension.create()
            self.send("add_#{dimension.name.underscore}".to_sym,d)
            self.update("#{dimension.name.underscore}_id".to_sym => d.id)
          end
        end
        
        def version!
          self.fetch_version = nil #incase it was set
          version_dimensions!
          version_collections!
        end

        def version_dimensions!
          unless self.class.dimensions.empty?
            self.class.dimensions.each do |o|
              o.version_for(self)
            end
          end
        end
        
        def version_collections!
          unless self.class.collections.empty?
            self.class.collections.each do |o|
              o.version_for(self)
            end
          end
        end
      end # InstanceMethods
    end #Versioned
  end
end
