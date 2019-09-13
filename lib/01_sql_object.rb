require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    # ...
    return @columns if !@columns.nil?
    columns = DBConnection.execute2(<<~SQL)[0]
    SELECT
      *
    FROM
      #{self.table_name}
    SQL
    @columns = columns.map{|col| col.to_sym}
  end

  def self.finalize!
    debugger
    @finalized = true
    self.columns.each do |col|
      define_method(col) {self.attributes[col] }
      define_method(col.to_s + "=") {|new_val| self.attributes[col] = new_val}
    end
  end

  def self.table_name=(table_name)
    # ...
    @table_name = table_name
  end

  def self.table_name
    # ...
    @table_name ||= self.name.tableize
  end

  def self.all
    # ...
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    # ...
  end

  def attributes
    # ...
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
  def method_missing(m, *args, &block)
    return super(m, *args, &block) if self.class.finalized?
    self.class.finalize!
    return self.send(m, *args, &block) if self.methods.include?(m)
    super(m, *args, &block)
  end

  private
  def self.finalized?
    @finalized ||= false
  end
end
