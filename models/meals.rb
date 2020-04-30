def run_sql(sql)
    conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'foodex'})
    records = conn.exec(sql)
    conn.close
    records
  end
  
  def all_meals()
    run_sql("SELECT * FROM week_planner ORDER BY id;")
  end

  def all_meal_details()
    run_sql("SELECT * FROM meal_details ORDER BY label;")
  end

  def meal_by_uri(label)
    run_sql("SELECT uri FROM meal_details WHERE label LIKE '%#{label}%';")
  end

  def update_dish(day_of_week, meal_course, label)
    run_sql("UPDATE week_planner SET #{meal_course} = '#{label}' WHERE day_of_week LIKE '%#{day_of_week}%';")
  end

  def add_dish_details(label, uri)
    run_sql("INSERT INTO meal_details (label, uri) VALUES ('#{label}', '#{uri}');")
  end

  def reset_planner()
    run_sql("UPDATE week_planner SET breakfast = Null;")
    run_sql("UPDATE week_planner SET lunch = Null;")
    run_sql("UPDATE week_planner SET dinner = Null;")
    
    run_sql("DELETE FROM meal_details;")
  end