module Loco
  
  class SQLiteAdapter < Adapter
    
    class RecordNotFound < StandardError
    end
    
    def create_record(record, &block)
      type = record.class
      record.id = generate_id(type)
      data = NSEntityDescription.insertNewObjectForEntityForName(type.to_s, inManagedObjectContext:context(type))
      record.serialize(root: false, include_id: true).each do |key, value|
        data.setValue(value, forKey:key)
      end
      save_data_for_type(type)
      load(type, record, data)
      block.call(record) if block.is_a? Proc
      record
    end
    
    def delete_record(record, &block)
      type = record.class
      data = request(type, { id: record.id }).first
      if data
        context(type).deleteObject(data)
        save_data_for_type(type)
        block.call(record) if block.is_a? Proc
        record
      else
        raise Loco::FixtureAdapter::RecordNotFound, "#{type} with the id `#{record.id}' could not be deleted."
      end
    end
    
    def find(record, id, &block)
      type = record.class
      data = request(type, { id: record.id }).first
      if data
        load(type, record, data)
        block.call(record) if block.is_a? Proc
        record
      else
        raise Loco::FixtureAdapter::RecordNotFound, "#{type} with the id `#{id}' could not be loaded."
      end
    end
    
    def find_all(type, records, &block)
      data = request(type)
      load(type, records, data)
      block.call(records) if block.is_a? Proc
      records
    end
    
    def find_many(type, records, ids, &block)
      data = request(type, { id: ids })
      load(type, records, data)
      block.call(records) if block.is_a? Proc
      records
    end
    
    def find_query(type, records, query, &block)
      data = request(type, query)
      load(type, records, data)
      block.call(records) if block.is_a? Proc
      records
    end
    
    def update_record(record, &block)
      type = record.class
      data = request(type, { id: record.id }).first
      if data
        record.serialize(root: false).each do |key, value|
          data.setValue(value, forKey:key)
        end
        save_data_for_type(type)
        load(type, record, data)
        block.call(record) if block.is_a? Proc
        record
      else
        raise Loco::FixtureAdapter::RecordNotFound, "#{type} with the id `#{record.id}' could not be updated."
      end
    end
    
    def serialize(record, options={})
      json = {}
      record.class.get_class_relationships.select{|relationship| relationship[:belongs_to] }.each do |relationship|
        key = "#{relationship[:belongs_to]}_id".to_sym
        json[key] = record.valueForKey(key)
      end
      super(record, options, json)
    end
    
  private
  
    def request(type, query=nil)
      request = NSFetchRequest.new
      request.entity = entity(type)
      request.sortDescriptors = [NSSortDescriptor.alloc.initWithKey('id', ascending:true)]
      unless query.nil?
        conditions = []
        values = []
        query.each do |key, value|
          if value.is_a? Array
            conditions << "#{key} IN %@"
          else
            conditions << "#{key} = %@"
          end
          values << value
        end
        request.predicate = NSPredicate.predicateWithFormat(conditions.join(' AND '), argumentArray:values) 
      end

      error = Pointer.new(:object)
      context(type).executeFetchRequest(request, error:error)
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
        
        properties = type.get_class_properties.select{|prop|
          prop[:type]
        }.map{|prop|
          property = NSAttributeDescription.new
          property.name = prop[:name].to_s
          case prop[:type].to_sym
          when :date
            property.attributeType = NSDateAttributeType
          when :integer
            property.attributeType = NSInteger32AttributeType
          when :float
            property.attributeType = NSFloatAttributeType
          when :string
            property.attributeType = NSStringAttributeType
          end
          property
        }
        
        type.get_class_relationships.select{|relationship| relationship[:belongs_to] }.each do |relationship|
          property = NSAttributeDescription.new
          property.name = "#{relationship[:belongs_to]}_id"
          property.attributeType = NSInteger32AttributeType
          properties << property
        end
        
        entity.properties = properties
        
        entity
      end
    end
    
    def generate_id(type)
      key = "loco.#{type.to_s.underscore.pluralize}.last_id"
      last_id = App::Persistence[key]
      if last_id.nil?
        last_id = 0 
        data = request(type)
        if data.length > 0
          last_id = data.sort_by{|obj| obj.valueForKey(:id).to_i }.last.id
        end
      end
      new_id = last_id.to_i + 1
      App::Persistence[key] = new_id
      new_id
    end
    
    def save_data_for_type(type)
      error = Pointer.new(:object)
      raise "Error when saving #{type}: #{error[0].description}" unless context(type).save(error)
    end
    
    def transform_data(type, data)
      if data.is_a? Array
        super(type, data.map{|object|
          data_item = {}
          
          type.get_class_properties.each do |property|
            key = property[:name].to_sym
            data_item[key] = object.valueForKey(key)
          end
          
          type.get_class_relationships.select{|relationship| relationship[:belongs_to] }.each do |relationship|
            key = "#{relationship[:belongs_to]}_id".to_sym
            data_item[key] = object.valueForKey(key)
          end
          
          data_item
        })
      else
        json = {}
        
        type.get_class_properties.each do |property|
          key = property[:name].to_sym
          json[key] = data.valueForKey(key)
        end
        
        type.get_class_relationships.select{|relationship| relationship[:belongs_to] }.each do |relationship|
          key = "#{relationship[:belongs_to]}_id".to_sym
          json[key] = data.valueForKey(key)
        end
        
        super(type, json)
      end
    end
    
  end
  
  # Let Core Data take care of NSDate serialization
  SQLiteAdapter.register_transform(:date, {
    serialize: lambda{|value|
      value
    },
    deserialize: lambda{|value|
      value
    }
  })
  
end
