require_relative "./01_sql_object"
class Cat < SQLObject

end

c = Cat.new
c.name = "tabitha"