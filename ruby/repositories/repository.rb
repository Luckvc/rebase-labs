require 'byebug'

class Repository
  def self.all(conn)
    results = conn.exec("SELECT * FROM #{table_name};").entries
    if results
      results.map do |result|
        create_object(result)
      end
    end
  end
  
  def self.find_by(field, value, conn)
    result = conn.exec("SELECT * FROM #{table_name} WHERE #{field} = '#{value}'").entries[0]

    create_object(result) if result
  end

  def self.find_by_id(id, conn)
    result = conn.exec("SELECT * FROM #{table_name} WHERE id = '#{id}'").entries[0]

    create_object(result) if result
  end
  
  def self.create(attributes, conn)
    result = conn.exec("INSERT INTO #{table_name()} (#{attributes.keys.join(', ')})
                        VALUES (#{attributes.values.map.with_index { |v, index| "$#{index + 1}" }.join(', ')})
                        RETURNING *", attributes.values).entries[0]

    create_object(result) if result
  end

  def self.find_or_create(attributes, conn)

  end

  def instance_attributes
    result = {}
    self.instance_variables.each do |attribute| 
      result[attribute.to_s.delete("@")] = self.instance_variable_get(attribute) 
    end
    result
  end

  private

  def self.create_object(result)
    attributes = result.transform_keys { |k| k.to_sym }
    new(**attributes)
  end

  def self.table_name
    name.downcase << 's'
  end
end