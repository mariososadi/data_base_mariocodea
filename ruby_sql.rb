require 'sqlite3'

class Chef
  def self.create_table
    Chef.db.execute(
      <<-SQL
        CREATE TABLE chefs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          first_name VARCHAR(64) NOT NULL,
          last_name VARCHAR(64) NOT NULL,
          birthday DATE NOT NULL,
          email VARCHAR(64) NOT NULL,
          phone VARCHAR(64) NOT NULL,
          created_at DATETIME NOT NULL,
          updated_at DATETIME NOT NULL
        );
      SQL
    )
  end

  def self.seed
    Chef.db.execute(
      <<-SQL
        INSERT INTO chefs
          (first_name, last_name, birthday, email, phone, created_at, updated_at)
        VALUES
          ('Ferran', 'Adriá', '1985-02-09', 'ferran.adria@elbulli.com', '42381093238', DATETIME('now'), DATETIME('now')),
          ('Maldonado', 'Emilio', '1987-03-22', 'emi.maldonado@elbulli.com', '41325678912', DATETIME('now'), DATETIME('now')),
          ('Sosa', 'Mario', '1990-08-14', 'mario.sosa@elbulli.com', '555689712345', DATETIME('now'), DATETIME('now')),
          ('Hidalgo', 'Luis', '1994-03-01', 'luis.hidalgo@elbulli.com', '456987512365', DATETIME('now'), DATETIME('now')),
          ('Sanchez', 'Miriam', '1988-06-07', 'miriam.sanchez@elbulli.com', '569849568763', DATETIME('now'), DATETIME('now'));

      SQL
    )
  end

  def self.all
    puts "[first_name, last_name, birthday, email, phone, created_at, updated_at]"
    Chef.db.execute(
      <<-SQL
      
      SELECT * FROM chefs;
    SQL
    ) do |row| p row
    end

  end

  def self.where(column_name, value)

    if @column_name =='id'
      @value.to_i
    else
      @value.to_s
    end

    Chef.db.execute(
      <<-SQL
      SELECT * FROM chefs
      WHERE "#{column_name}" = "#{value}";
    SQL
    ) do |row| p row
    end

  end

  def self.insert(first_name_in, last_name_in, birthday_in, email_in, phone_in)
    Chef.db.execute(
      <<-SQL
        INSERT INTO chefs
          (first_name, last_name, birthday, email, phone, created_at, updated_at)
        VALUES
          ("#{first_name_in}", "#{last_name_in}", "#{birthday_in}", "#{email_in}", "#{phone_in}", DATETIME('now'), DATETIME('now'));
          

      SQL
    )
  end

  def self.delete(column_name, value)

    if @column_name =='id'
      @value.to_i
    else
      @value.to_s
    end
    Chef.db.execute(
      <<-SQL
        DELETE FROM chefs
        WHERE "#{column_name}" = "#{value}";

      SQL
    )
  end

  def self.update(column_name, value, column_update, value_update)

    if @column_name =='id'
      @value.to_i
    else
      @value.to_s
    end
    Chef.db.execute(
      <<-SQL
        UPDATE chefs
        SET "#{column_update}" = "#{value_update}", updated_at = DATETIME('now')
        WHERE "#{column_name}" = "#{value}";

      SQL
    )
  end



  private

  def self.db
    @@db ||= SQLite3::Database.new("chefs.db")
  end

end




line = ARGV
command = line.slice!(0)

case command
  when "all" then Chef.all
  when "create_table" then Chef.create_table
  when "seed" then Chef.seed
  when "select_all" then Chef.where(line[0],line[1])
  when "insert" then Chef.insert(line[0],line[1],line[2],line[3],line[4])
  when "delete" then Chef.delete(line[0],line[1])
  when "update" then Chef.update(line[0],line[1],line[2],line[3])
end

