DROP TABLE time_dimension;
SELECT * FROM time_dimension;

CREATE TABLE time_dimension (
    TimeID SERIAL NOT NULL PRIMARY KEY,
    FullTime TIME NOT NULL,
    HourOfDay SMALLINT NOT NULL,
    MinuteOfHour SMALLINT NOT NULL,
    SecondOfMinute SMALLINT NOT NULL,
    AmPm CHAR(2) NOT NULL,
    TimeOfDayCategory VARCHAR(20) NOT NULL -- e.g., Morning, Afternoon, Evening, Night
);

INSERT INTO time_dimension (FullTime, HourOfDay, MinuteOfHour, SecondOfMinute, AmPm, TimeOfDayCategory)
SELECT
    (hour || ':' || minute || ':' || second)::TIME AS FullTime,
    hour AS HourOfDay,
    minute AS MinuteOfHour,
    second AS SecondOfMinute,
    CASE WHEN hour >= 12 THEN 'PM' ELSE 'AM' END AS AmPm,
    CASE
        WHEN hour >= 5 AND hour < 12 THEN 'Morning'
        WHEN hour >= 12 AND hour < 17 THEN 'Afternoon'
        WHEN hour >= 17 AND hour < 21 THEN 'Evening'
        ELSE 'Night'
    END AS TimeOfDayCategory
FROM
    generate_series(0, 23) AS hour,
    generate_series(0, 59) AS minute,
    generate_series(0, 59) AS second
ORDER BY
    FullTime;