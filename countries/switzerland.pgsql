------------------------------------------
------------------------------------------
-- Switzerland Holidays
------------------------------------------
------------------------------------------
--
CREATE OR REPLACE FUNCTION holidays.switzerland(p_province TEXT, p_start_year INTEGER, p_end_year INTEGER)
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
	-- Provinces
	PROVINCES TEXT[] := ARRAY[
		'AG', 'AR', 'AI', 'BL', 'BS', 'BE', 'FR', 'GE', 'GL', 'GR', 'JU', 'LU',
		'NE', 'NW', 'OW', 'SG', 'SH', 'SZ', 'SO', 'TG', 'TI', 'UR', 'VD', 'VS',
		'ZG', 'ZH'
	];
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

		-- public holidays
		t_holiday.datestamp := make_date(t_year, JANUARY, 1);
		t_holiday.description := 'Neujahrestag';
		RETURN NEXT t_holiday;

		if p_province IN (
			'AG', 'BE', 'FR', 'GE', 'GL', 'GR', 'JU', 'LU', 'NE', 'OW', 'SH',
			'SO', 'TG', 'VD', 'ZG', 'ZH'
		) THEN
			t_holiday.datestamp := make_date(t_year, JANUARY, 2);
			t_holiday.description := 'Berchtoldstag';
			RETURN NEXT t_holiday;
		END IF;

		IF p_province IN ('SZ', 'TI', 'UR') THEN
			t_holiday.datestamp := make_date(t_year, JANUARY, 6);
			t_holiday.description := 'Heilige Drei Könige';
			RETURN NEXT t_holiday;
		END IF;

		IF p_province = 'NE' THEN
			t_holiday.datestamp := make_date(t_year, MARCH, 1);
			t_holiday.description := 'Jahrestag der Ausrufung der Republik';
			RETURN NEXT t_holiday;
		END IF;

		IF p_province IN ('NW', 'SZ', 'TI', 'UR', 'VS') THEN
			t_holiday.datestamp := make_date(t_year, MARCH, 19);
			t_holiday.description := 'Josefstag';
			RETURN NEXT t_holiday;
		END IF;

		-- Näfelser Fahrt (first Thursday in April but not in Holy Week)
		IF p_province = 'GL' AND t_year >= 1835 THEN
			t_datestamp := holidays.find_nth_weekday_date(make_date(t_year, APRIL, 1), FRIDAY, 1);
			IF (t_datestamp != (holidays.easter(t_year) - '2 Days'::INTERVAL)) THEN
				t_holiday.datestamp := holidays.find_nth_weekday_date(make_date(t_year, APRIL, 1), THURSDAY, 1);
				t_holiday.description := 'Näfelser Fahrt';
				RETURN NEXT t_holiday;
			ELSE
				t_holiday.datestamp := holidays.find_nth_weekday_date(make_date(t_year, APRIL, 8), THURSDAY, 1);
				t_holiday.description := 'Näfelser Fahrt';
				RETURN NEXT t_holiday;
			END IF;
		END IF;

		-- Easter Related Holidays
		t_datestamp := holidays.easter(t_year);

		-- It's a Holiday on a Sunday
		t_holiday.datestamp := t_datestamp;
		t_holiday.description := 'Ostern';
		RETURN NEXT t_holiday;

		-- VS don't have easter
		IF p_province != 'VS' THEN
			-- Good Friday
			t_holiday.datestamp := t_datestamp - '2 Days'::INTERVAL;
			t_holiday.description := 'Karfreitag';
			RETURN NEXT t_holiday;

			-- Easter Monday
			t_holiday.datestamp := t_datestamp + '1 Day'::INTERVAL;
			t_holiday.description := 'Ostermontag';
			RETURN NEXT t_holiday;
		END IF;

		t_holiday.datestamp := t_datestamp + '39 Days'::INTERVAL;
		t_holiday.description := 'Auffahrt';
		RETURN NEXT t_holiday;

		-- it's a Holiday on a Sunday
		t_holiday.datestamp := t_datestamp + '49 Days'::INTERVAL;
		t_holiday.description := 'Pfingsten';
		RETURN NEXT t_holiday;

		t_holiday.datestamp := t_datestamp + '50 Days'::INTERVAL;
		t_holiday.description := 'Pfingstmontag';
		RETURN NEXT t_holiday;

		IF p_province IN ('AI', 'JU', 'LU', 'NW', 'OW', 'SZ', 'TI', 'UR', 'VS', 'ZG') THEN
			t_holiday.datestamp := t_datestamp + '60 Days'::INTERVAL;
			t_holiday.description := 'Fronleichnam';
			RETURN NEXT t_holiday;
		END IF;

		IF p_province IN ('BL', 'BS', 'JU', 'NE', 'SH', 'SO', 'TG', 'TI','ZH') THEN
			t_holiday.datestamp := make_date(t_year, MAY, 1);
		END IF;
		t_holiday.description := 'Tag der Arbeit';
		RETURN NEXT t_holiday;

		IF p_province = 'JU' THEN
			t_holiday.datestamp := make_date(t_year, JUNE, 23);
			t_holiday.description := 'Fest der Unabhängigkeit';
			RETURN NEXT t_holiday;
		END IF;

		IF p_province = 'TI' THEN
			t_holiday.datestamp := make_date(t_year, JUNE, 29);
			t_holiday.description := 'Peter und Paul';
			RETURN NEXT t_holiday;
		END IF;

		IF t_year >= 1291 THEN
			t_holiday.datestamp := make_date(t_year, AUGUST, 1);
			t_holiday.description := 'Nationalfeiertag';
			RETURN NEXT t_holiday;
		END IF;

		IF p_province IN ('AI', 'JU', 'LU', 'NW', 'OW', 'SZ', 'TI', 'UR', 'VS', 'ZG') THEN
			t_holiday.datestamp := make_date(t_year, AUGUST, 15);
			t_holiday.description := 'Mariä Himmelfahrt';
			RETURN NEXT t_holiday;
		END IF;

		IF p_province = 'VD' THEN
			-- Monday after the third Sunday of September
			t_datestamp := holidays.find_nth_weekday_date(make_date(t_year, SEPTEMBER, 1), SUNDAY, 3);
			t_holiday.datestamp := holidays.find_nth_weekday_date(t_datestamp, MONDAY, 1);
			t_holiday.description := 'Lundi du Jeûne';
			RETURN NEXT t_holiday;
		END IF;

		IF p_province = 'OW' THEN
			t_holiday.datestamp := make_date(t_year, SEPTEMBER, 25);
			t_holiday.description := 'Bruder Klaus';
			RETURN NEXT t_holiday;
		END IF;

		IF p_province IN ('AI', 'GL', 'JU', 'LU', 'NW', 'OW', 'SG', 'SZ', 'TI', 'UR', 'VS', 'ZG') THEN
			t_holiday.datestamp := make_date(t_year, NOVEMBER, 1);
			t_holiday.description := 'Allerheiligen';
			RETURN NEXT t_holiday;
		END IF;

		IF p_province IN ('AI', 'LU', 'NW', 'OW', 'SZ', 'TI', 'UR', 'VS', 'ZG') THEN
			t_holiday.datestamp := make_date(t_year, DECEMBER, 8);
			t_holiday.description := 'Mariä Empfängnis';
			RETURN NEXT t_holiday;
		END IF;

		IF p_province = 'GE' THEN
			t_holiday.datestamp := make_date(t_year, DECEMBER, 12);
			t_holiday.description := 'Escalade de Genève';
			RETURN NEXT t_holiday;
		END IF;

		t_holiday.datestamp := make_date(t_year, DECEMBER, 25);
		t_holiday.description := 'Weihnachten';
		RETURN NEXT t_holiday;

		IF p_province IN (
			'AG', 'AR', 'AI', 'BL', 'BS', 'BE', 'FR', 'GL', 'GR', 'LU', 'NE',
			'NW', 'OW', 'SG', 'SH', 'SZ', 'SO', 'TG', 'TI', 'UR', 'ZG', 'ZH'
		) THEN
			t_holiday.datestamp := make_date(t_year, DECEMBER, 26);
			t_holiday.description := 'Stephanstag';
			RETURN NEXT t_holiday;
		END IF;

		IF p_province = 'GE' THEN
			t_holiday.datestamp := make_date(t_year, DECEMBER, 31);
			t_holiday.description := 'Wiederherstellung der Republik';
			RETURN NEXT t_holiday;
		END IF;

	END LOOP;
END;

$$ LANGUAGE plpgsql;