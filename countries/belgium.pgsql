------------------------------------------
------------------------------------------
-- <country> Holidays
-- https://www.belgium.be/nl/over_belgie/land/belgie_in_een_notendop/feestdagen
-- https://nl.wikipedia.org/wiki/Feestdagen_in_Belgi%C3%AB
------------------------------------------
------------------------------------------
--
CREATE OR REPLACE FUNCTION holidays.country(p_start_year INTEGER, p_end_year INTEGER)
RETURNS SETOF holidays.holiday
AS $$

DECLARE
	-- Month Constants
	JANUARY INTEGER := 1;
	FEBRUARY INTEGER := 2;
	MARCH INTEGER := 3;
	APRIL INTEGER := 4;
	MAY INTEGER := 5;
	JUNE INTEGER := 6;
	JULY INTEGER := 7;
	AUGUST INTEGER := 8;
	SEPTEMBER INTEGER := 9;
	OCTOBER INTEGER := 10;
	NOVEMBER INTEGER := 11;
	DECEMBER INTEGER := 12;
	-- Weekday Constants
	SUNDAY INTEGER := 0;
	MONDAY INTEGER := 1;
	TUESDAY INTEGER := 2;
	WEDNESDAY INTEGER := 3;
	THURSDAY INTEGER := 4;
	FRIDAY INTEGER := 5;
	SATURDAY INTEGER := 6;
	WEEKEND INTEGER[] := ARRAY[0, 6];
	-- Primary Loop
	t_years INTEGER[] := (SELECT ARRAY(SELECT generate_series(p_start_year, p_end_year)));
	-- Holding Variables
	t_year INTEGER;
	t_datestamp DATE;
	t_dt1 DATE;
	t_dt2 DATE;
	t_holiday holidays.holiday%rowtype;

BEGIN
	FOREACH t_year IN ARRAY t_years
	LOOP

-- New years
		t_holiday.datestamp := make_date(t_year, JANUARY, 1);
		t_holiday.description := 'Nieuwjaarsdag';
		RETURN NEXT t_holiday;

		easter_date = easter(year)

		-- Easter
		self[easter_date] = 'Pasen'

		-- Second easter day
		self[easter_date + rd(days=1)] = 'Paasmaandag'

		-- Ascension day
		self[easter_date + rd(days=39)] = 'O.L.H. Hemelvaart'

		-- Pentecost
		self[easter_date + rd(days=49)] = 'Pinksteren'

		-- Pentecost monday
		self[easter_date + rd(days=50)] = 'Pinkstermaandag'

		-- International Workers' Day
		t_holiday.datestamp := make_date(t_year, MAY, 1);
		t_holiday.description := 'Dag van de Arbeid';
		RETURN NEXT t_holiday;

		-- Belgian National Day
		t_holiday.datestamp := make_date(t_year, JUL, 21);
		t_holiday.description := 'Nationale feestdag';
		RETURN NEXT t_holiday;

		-- Assumption of Mary
		t_holiday.datestamp := make_date(t_year, AUG, 15);
		t_holiday.description := 'O.L.V. Hemelvaart';
		RETURN NEXT t_holiday;

		-- All Saints' Day
		t_holiday.datestamp := make_date(t_year, NOV, 1);
		t_holiday.description := 'Allerheiligen';
		RETURN NEXT t_holiday;

		-- Armistice Day
		t_holiday.datestamp := make_date(t_year, NOV, 11);
		t_holiday.description := 'Wapenstilstand';
		RETURN NEXT t_holiday;

		-- First christmas
		t_holiday.datestamp := make_date(t_year, DEC, 25);
		t_holiday.description := 'Kerstmis';
		RETURN NEXT t_holiday;

	END LOOP;
END;

$$ LANGUAGE plpgsql;