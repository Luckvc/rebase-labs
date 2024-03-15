# frozen_string_literal: true

class Repository
  def self.all(conn)
    results = conn.exec("SELECT * FROM #{table_name};").entries
    return unless results

    results.map do |result|
      create_object(result)
    end
  end

  def self.find_by(field, value, conn)
    result = conn.exec("SELECT * FROM #{table_name} WHERE #{field} = '#{value}'").entries[0]
    return create_object(result) if result

    nil
  end

  def self.find_by_id(id, conn)
    result = conn.exec("SELECT * FROM #{table_name} WHERE id = '#{id}'").entries[0]

    create_object(result) if result
  end

  def self.create(attributes, conn)
    result = conn.exec("INSERT INTO #{table_name} (#{attributes.keys.join(', ')})
                        VALUES (#{attributes.values.map.with_index { |_v, index| "$#{index + 1}" }.join(', ')})
                        RETURNING *", attributes.values).entries[0]

    create_object(result) if result
  end

  def instance_attributes
    result = {}
    instance_variables.each do |attribute|
      result[attribute.to_s.delete('@')] = instance_variable_get(attribute)
    end
    result
  end

  def self.create_object(result)
    attributes = result.transform_keys(&:to_sym)
    new(**attributes)
  end

  def self.table_name
    name.downcase << 's'
  end
end
