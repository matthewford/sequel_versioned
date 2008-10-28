module Sequel
  module Plugins
    # is :versioned_collection
    #
    # Assumptions:
    # 
    # * there is one_to_many with a reciprocated many_to_one between the parent and versioned objects
    # * the parent has an attr, fetch_version, to fetch specific version, otherwise it will get latest version
    # * the parent has versioned_objects_version attributes defined
    
    module VersionedCollection
      #Included class methods
      module ClassMethods
        # Returns the current version for the accosiation with object or the version specified
        def fetch_for(object, fetch_version=nil)
          key = self.association_reflection(object.model.name.underscore.to_sym).default_right_key.to_sym
          if fetch_version
            self.filter(key => object.pk, :version => fetch_version)
          else 
            self.filter(key => object.pk, :version => object.send("#{self.name.pluralize.underscore}_version".to_sym))
          end          
        end
        # duplicate and increment version; update the forigen key and version (number) attributes on object
        def version_for(object)
          old_objs = self.fetch_for(object).all
          unless old_objs.empty?
          old_version_sym = "#{self.name.pluralize.underscore}_version".to_sym
          old_version = object.send(old_version_sym)

            old_objs.each do |o|
              o_values = o.values
              o_values.delete(:id)
              new_object = self.create(o_values.merge(:version => old_version + 1))
            end
          
            object.update({old_version_sym => old_version + 1 })
          end
        end
      end # ClassMethods
    end #Versioned
  end
end
