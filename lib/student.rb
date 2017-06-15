class Student

  attr_accessor :name, :grade
  attr_reader :id

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize (name, grade, id =nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table

    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    );
    SQL

    DB[:conn].execute(sql)

  end

  def self.drop_table

    sql = <<-SQL
    DROP TABLE students;
    SQL

    DB[:conn].execute(sql)

  end

  def save

    sql = <<-SQL
    INSERT INTO students (
      name,
      grade
    )
    VALUES (?,?);
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    sql = <<-SQL
    SELECT id FROM students
    ORDER BY id DESC
    LIMIT 1;
    SQL

    @id = DB[:conn].execute(sql).flatten[0]

  end

  def self.create(input_hash)

    student_name = input_hash[:name]
    student_grade = input_hash[:grade]
    student = Student.new(student_name, student_grade)
    student.save
    student

  end

end
