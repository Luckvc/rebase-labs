class Repository
  def self.all(conn)
    conn.exec("SELECT * FROM #{table_name};")
  end
  
  def self.find_by(field, value, conn)
    conn.exec("SELECT * FROM #{table_name} WHERE #{field} = '#{value}'")
  end
  
  def self.create(attributes, conn)
    conn.exec("INSERT INTO #{table_name()} (#{attributes.keys.join(', ')}) VALUES ('#{attributes.values.join(', ')''})") # tem que colocar entre aspas
  end

  def self.find_or_create(attributes, conn)
  end

  private

  def self.table_name
    name.downcase << 's'
  end
end
