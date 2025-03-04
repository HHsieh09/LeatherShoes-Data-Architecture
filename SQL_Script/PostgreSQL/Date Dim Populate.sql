CREATE TABLE date_dimension (
  DateID              INTEGER                     NOT NULL PRIMARY KEY,
  -- DATE
  FullDate            DATE                        NOT NULL,
  AUFormatDate        CHAR(10)                    NOT NULL,
  USFormatDate        CHAR(10)                    NOT NULL,
  -- YEAR
  YearNumber          SMALLINT                    NOT NULL,
  YearWeekNumber      SMALLINT                    NOT NULL,
  YearDayNumber       SMALLINT                    NOT NULL,
  AUFiscalYearNumber  SMALLINT                    NOT NULL,
  USFiscalYearNumber  SMALLINT                    NOT NULL,
  -- QUARTER
  QTRNumber           SMALLINT                    NOT NULL,
  AUFiscalQTRNumber   SMALLINT                    NOT NULL,
  USFiscalQTRNumber   SMALLINT                    NOT NULL,
  -- MONTH
  MonthNumber         SMALLINT                    NOT NULL,
  MonthName           CHAR(9)                     NOT NULL,
  MonthDayNumber      SMALLINT                    NOT NULL,
  -- WEEK
  WeekDayNumber       SMALLINT                    NOT NULL,
  -- DAY
  DayName             CHAR(9)                     NOT NULL,
  DayIsWeekday        SMALLINT                    NOT NULL,
  DayIsLastOfMonth    SMALLINT                    NOT NULL
) ;
--Populate it:

INSERT INTO date_dimension
  SELECT
    cast(seq + 1 AS INTEGER)                                      AS DateID,
-- DATE
    datum                                                         AS FullDate,
    TO_CHAR(datum, 'DD/MM/YYYY') :: CHAR(10)                      AS AUFormatDate,
    TO_CHAR(datum, 'MM/DD/YYYY') :: CHAR(10)                      AS USFormatDate,
-- YEAR
    cast(extract(YEAR FROM datum) AS SMALLINT)                    AS YearNumber,
    cast(extract(WEEK FROM datum) AS SMALLINT)                    AS YearWeekNumber,
    cast(extract(DOY FROM datum) AS SMALLINT)                     AS YearDayNumber,
    cast(to_char(datum + INTERVAL '6' MONTH, 'yyyy') AS SMALLINT) AS AUFiscalYearNumber,
    cast(to_char(datum + INTERVAL '3' MONTH, 'yyyy') AS SMALLINT) AS USFiscalYearNumber,
-- QUARTER
    cast(to_char(datum, 'Q') AS SMALLINT)                         AS QTRNumber,
    cast(to_char(datum + INTERVAL '6' MONTH, 'Q') AS SMALLINT)    AS AUFiscalQTRNumber,
    cast(to_char(datum + INTERVAL '3' MONTH, 'Q') AS SMALLINT)    AS USFiscalQTRNumber,
-- MONTH
    cast(extract(MONTH FROM datum) AS SMALLINT)                   AS MonthNumber,
    to_char(datum, 'Month')                                       AS MonthName,
    cast(extract(DAY FROM datum) AS SMALLINT)                     AS MonthDayNumber,
-- WEEK
    cast(to_char(datum, 'D') AS SMALLINT)                         AS WeekDayNumber,
-- DAY
    to_char(datum, 'Day')                                         AS DayName,
    CASE WHEN to_char(datum, 'D') IN ('1', '7')
      THEN 0
    ELSE 1 END                                                    AS DayIsWeekday,
    CASE WHEN
      extract(DAY FROM (datum + (1 - extract(DAY FROM datum)) :: INTEGER +
                        INTERVAL '1' MONTH) :: DATE -
                       INTERVAL '1' DAY) = extract(DAY FROM datum)
      THEN 1
    ELSE 0 END                                                    AS DayIsLastOfMonth
  FROM
    -- Generate days for the next ~40 years starting from 2005.
    (
      SELECT
        '2000-01-01' :: DATE + generate_series AS datum,
        generate_series                        AS seq
      FROM generate_series(0, 100 * 365, 1)
    ) DQ
  ORDER BY 1;