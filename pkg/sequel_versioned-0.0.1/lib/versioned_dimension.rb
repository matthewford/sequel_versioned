module Sequel
  module Plugins
    # is :versioned_dimension
    #
    # Assumptions:
    # 
    # * there is one_to_many with a reciprocated many_to_one between the parent and versioned dimensions
    # * the parent has an attr, fetch_version, to fetch specific version, otherwise it will get latest version
    # * the parent has versioned_dimension_id and versioned_dimension_version attributes defined
    # * the versioned_dimension has parent_id defined
    module VersionedDimension
      #Included class methods
      module ClassMethods
        # Returns the current version for the accosiation with object or the version specified
        def fetch_for(object, fetch_version=nil)
          if fetch_version
            self[self.association_reflection(object.model.name.underscore.to_sym).default_right_key => object.pk, :version => fetch_version]
          else 
            self[object.send("#{self.name.underscore}_id".to_sym)]
          end
        end
        # duplicate and increment version; update the forigen key and version (number) attributes on object
        def version_for(object)
         old_obj = self.fetch_for(object).values
         old_obj.delete(:id)
         old_version = old_obj.delete(:version)
         o = self.create(old_obj.merge({:version => old_version + 1}))
         object.update({"#{self.name.underscore}_id" => o.pk, "#{self.name.underscore}_version" => o.version})
        end
  
      end # ClassMethods
    end #Versioned
  end
end
