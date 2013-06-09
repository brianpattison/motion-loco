module Loco
  
  class SQLiteAdapter < Adapter
    
    class RecordNotFound < StandardError
    end
    
    def create_record(record, &block)
      record.id = generate_id(record.class)
      object = NSEntityDescription.insertNewObjectForEntityForName(record.class.to_s, inManagedObjectContext:context(record.class))
      record.class.get_class_properties.each do |property|
        key = property[:name].to_sym
        object.setValue(record.valueForKey(key).to_s, forKey:key)
      end
      save_data_for_type(record.class)
      block.call(record) if block.is_a? Proc
      record
    end
    
    def delete_record(record, &block)
      object = objects_for_type(record.class, { id: record.id }).first
      if object
        context(record.class).deleteObject(object)
        save_data_for_type(record.class)
        block.call(record) if block.is_a? Proc
        record
      else
        raise Loco::FixtureAdapter::RecordNotFound, "#{record.class} with the id `#{id}' could not be deleted."
      end
    end
    
    def find(record, id, &block)
      object = objects_for_type(record.class, { id: record.id }).first
      if object
        record.load(id, data_from_results(object, record.class))
        block.call(record) if block.is_a? Proc
        record
      else
        raise Loco::FixtureAdapter::RecordNotFound, "#{record.class} with the id `#{id}' could not be loaded."
      end
    end
    
    def find_all(type, records, &block)
      results = objects_for_type(type)
      records.load(type, data_from_results(results, type))
      block.call(records) if block.is_a? Proc
      records
    end
    
    def find_many(type, records, ids, &block)
      results = objects_for_type(type, { ids: ids })
      records.load(type, data_from_results(results, type))
      block.call(records) if block.is_a? Proc
      records
    end
    
    def find_query(type, records, query, &block)
      results = objects_for_type(type, query)
      records.load(type, data_from_results(results, type))
      block.call(records) if block.is_a? Proc
      records
    end
    
    def update_record(record, &block)
      object = objects_for_type(record.class, { id: record.id }).first
      if object
        record.class.get_class_properties.each do |property|
          key = property[:name].to_sym
          object.setValue(record.valueForKey(key), forKey:key)
        end
        save_data_for_type(record.class)
        block.call(record) if block.is_a? Proc
        record
      else
        raise Loco::FixtureAdapter::RecordNotFound, "#{record.class} with the id `#{id}' could not be updated."
      end
    end
    
  private
  
    def objects_for_type(type, query=nil)
      request = NSFetchRequest.new
      request.entity = entity(type)
      unless query.nil?
        conditions = []
        values = []
        query.each do |key, value|
          conditions << "#{key} = %@"
          values << value
        end
        request.predicate = NSPredicate.predicateWithFormat(conditions.join(' AND '), argumentArray:values) 
      end

      error = Pointer.new(:object)
      objects = context(type).executeFetchRequest(request, error:error)
    end
    
    def data_from_results(results, type)
      if results.is_a? Array
        results.map{|object|
          data_item = {}
          type.get_class_properties.each do |property|
            key = property[:name].to_sym
            data_item[key] = object.valueForKey(key)
          end
          data_item
        }
      else
        data = {}
        type.get_class_properties.each do |property|
          key = property[:name].to_sym
          data[key] = results.valueForKey(key)
        end
        data
      end
    end
  
    def context(type)
      @context ||= begin
        model = NSManagedObjectModel.new
        model.entities = [entity(type)]

        store = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(model)
        store_url = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), "Documents", "loco.#{type.to_s.underscore.pluralize}.sqlite"))
        Loco.debug(store_url.absoluteString)
        error = Pointer.new(:object)
        raise "Can't add persistent SQLite store: #{error[0].description}" unless store.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:store_url, options:nil, error:error)

        context = NSManagedObjectContext.new
        context.persistentStoreCoordinator = store
        context
      end
    end
    
    def entity(type)
      @entity ||= begin
        entity = NSEntityDescription.new
        entity.name = type.to_s
        entity.properties = type.get_class_properties.map{|class_property|
          property = NSAttributeDescription.new
          property.name = class_property[:name].to_s
          property.attributeType = NSStringAttributeType
          property
        }
        entity
      end
    end
    
    def generate_id(type)
      key = "loco.#{type.to_s.underscore}.last_id"
      last_id = App::Persistence[key]
      if last_id.nil?
        last_id = 0 
        existing_objects = objects_for_type(type)
        if existing_objects.length > 0
          last_id = existing_objects.sort_by{|obj| obj.valueForKey(:id).to_i }.last.id
        end
      end
      new_id = last_id.to_i + 1
      App::Persistence[key] = new_id
      new_id
    end
    
    def save_data_for_type(type)
      error = Pointer.new(:object)
      raise "Error when saving for #{type}: #{error[0].description}" unless context(type).save(error)
    end
    
  end
  
end
