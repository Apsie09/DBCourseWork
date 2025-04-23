USE airline_management;

DELIMITER $$

CREATE PROCEDURE sp_monthly_meal_report(
    IN p_month INT,
    IN p_year  INT
)
BEGIN
  DECLARE done       INT DEFAULT 0;
  DECLARE v_ft_id     INT;
  DECLARE v_count     INT;
  DECLARE v_desc      VARCHAR(100);

  -- 1) курсор за всички различни food_type_id в зададения период
  DECLARE cur_ft CURSOR FOR
    SELECT DISTINCT food_type_id
      FROM Flights
     WHERE MONTH(flight_date) = p_month
       AND YEAR(flight_date)  = p_year;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  -- 2) временна таблица за съхранение на резултатите
  CREATE TEMPORARY TABLE IF NOT EXISTS temp_meal_stats (
    food_type_id INT PRIMARY KEY,
    description  VARCHAR(100),
    meal_count   INT
  ) ENGINE=MEMORY;

  -- 3) обхождаме типовете храна и смятаме броя поръчки
  OPEN cur_ft;
  read_loop: LOOP
    FETCH cur_ft INTO v_ft_id;
    IF done THEN 
      LEAVE read_loop;
    END IF;

    SELECT description INTO v_desc 
      FROM Food_Types 
     WHERE food_type_id = v_ft_id;

    SELECT COUNT(b.booking_id) INTO v_count
      FROM Flights f
      LEFT JOIN Bookings b ON f.flight_id = b.flight_id
     WHERE f.food_type_id = v_ft_id
       AND MONTH(f.flight_date) = p_month
       AND YEAR(f.flight_date)  = p_year;

    INSERT INTO temp_meal_stats
    VALUES (v_ft_id, v_desc, v_count);
  END LOOP;
  CLOSE cur_ft;

  -- 4) връщаме резултатите
  SELECT * FROM temp_meal_stats;

  -- 5) изчистваме временната таблица
  DROP TEMPORARY TABLE temp_meal_stats;
END$$

DELIMITER ;

CALL sp_monthly_meal_report(6, 2024);