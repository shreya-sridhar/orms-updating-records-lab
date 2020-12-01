require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(name, grade)
     @name = name
     @grade = grade
     @id = nil
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT);"
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def save
    if not self.id
      sql = "INSERT INTO students (name, grade) 
      VALUES (?, ?)"

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    else
      self.update
    end
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row)
    student = Student.new(row[1],row[2])
    student.id = row[0]
    student
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?;"
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?;"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
  
end

# .find_by_name
# returns an instance of student that matches the name from the DB (FAILED - 9)
# #update
# updates the record associated with a given instance (FAILED - 10)
