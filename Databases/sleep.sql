DROP TABLE SLEEP;
CREATE TABLE Sleep (
    UserID INT,
    time_stamp TIMESTAMP,
    TotalDuration DECIMAL(10, 2), -- Total sleep duration in hours
    Deep DECIMAL(10, 2), -- Deep sleep duration in hours
    Light DECIMAL(10, 2), -- Light sleep duration in hours
    Rem DECIMAL(10, 2), -- REM sleep duration in hours
    SleepQualityIndex DECIMAL(10, 2) -- Sleep quality index
);

ALTER TABLE Sleep MODIFY time_stamp TIMESTAMP;

CREATE OR REPLACE TRIGGER calculate_sleep_index_trigger
BEFORE INSERT OR UPDATE ON Sleep
FOR EACH ROW
BEGIN
    -- Check if TotalDuration is not zero to avoid division by zero error
    IF :NEW.TotalDuration <> 0 THEN
        -- Calculate SleepQualityIndex based on the fetched values from the table
        :NEW.SleepQualityIndex := ((:NEW.Deep / :NEW.TotalDuration) * 0.25) + ((:NEW.Light / :NEW.TotalDuration) * 0.5) + ((:NEW.Rem / :NEW.TotalDuration) * 0.25);
    ELSE
        -- Set SleepQualityIndex to NULL if TotalDuration is zero
        :NEW.SleepQualityIndex := NULL;
    END IF;
END;
/



INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-01 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-02 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 4, 1, 4);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-03 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 2, 2, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-04 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 3, 3, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-05 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 2, 3, 5);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-06 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 2, 3, 5);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-07 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 7, 2, 3);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-08 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 11, 7, 3, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-09 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 11, 7, 3, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-10 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-11 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 3, 4, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-12 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 7, 4, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-13 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 11, 4, 6, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-14 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 2, 5, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-15 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 3, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-16 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 4, 1, 4);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-17 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 2, 1, 4);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-18 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 4, 4, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-19 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 3, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-20 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-21 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 3, 2, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-22 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 5, 3, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-23 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-24 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 2, 3, 3);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-25 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 6, 2, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-26 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 11, 8, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-27 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 11, 2, 3, 6);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-28 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 2, 1, 9);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-29 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 4, 1, 7);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (1, TO_TIMESTAMP('2024-03-30 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 2, 4, 3);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-01 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-02 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 7, 2, 3);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-03 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 6, 3, 3);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-04 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 4, 2, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-05 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 6, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-06 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 2, 1, 3);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-07 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-08 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 11, 3, 7, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-09 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 7, 1, 4);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-10 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-11 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 5, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-12 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 5, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-13 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-14 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 8, 3, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-15 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 5, 4, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-16 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-17 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 3, 1, 4);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-18 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 4, 1, 5);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-19 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 11, 6, 2, 3);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-20 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 4, 3, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-21 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 7, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-22 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 3, 1, 8);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-23 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 3, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-24 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 2, 7, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-25 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 11, 6, 4, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-26 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-27 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 3, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-28 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 2, 1, 3);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-29 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 2, 1, 3);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (2, TO_TIMESTAMP('2024-03-30 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 4, 1, 3);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-01 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 5, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-02 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 7, 4, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-03 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 7, 4, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-04 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 3, 4, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-05 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 7, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-06 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 5, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-07 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 4, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-08 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 3, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-09 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 3, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-10 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 7, 3, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-11 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-12 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 3, 4, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-13 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 3, 4, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-14 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-15 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 2, 5, 5);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-16 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 4, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-17 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 11, 8, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-18 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-19 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 3, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-20 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 8, 1, 3);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-21 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 3, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-22 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 3, 1, 3);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-23 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-24 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 2, 1, 3);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-25 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 7, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-26 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 5, 3, 4);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-27 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 2, 2, 8);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-28 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 3, 2, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-29 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 11, 4, 2, 5);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (3, TO_TIMESTAMP('2024-03-30 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 5, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-01 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 2, 3, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-02 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 11, 8, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-03 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 3, 2, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-04 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 9, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-05 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 11, 4, 2, 5);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-06 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 3, 3, 6);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-07 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 3, 3, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-08 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 8, 2, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-09 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 3, 4, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-10 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 2, 6, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-11 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 5, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-12 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-13 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 4, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-14 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 3, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-15 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 3, 1, 4);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-16 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 3, 3, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-17 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 4, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-18 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 4, 2, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-19 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 3, 3, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-20 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 2, 5, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-21 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 3, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-22 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 7, 1, 4);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-23 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 3, 2, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-24 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 2, 2, 3);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-25 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 2, 2, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-26 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 5, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-27 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 5, 4, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-28 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 6, 2, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-29 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 2, 1, 7);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (4, TO_TIMESTAMP('2024-03-30 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 3, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-01 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 5, 2, 5);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-02 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 5, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-03 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 4, 1, 4);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-04 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 11, 8, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-05 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-06 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 2, 4, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-07 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-08 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 3, 2, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-09 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 3, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-10 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 5, 3, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-11 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 5, 4, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-12 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 4, 3, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-13 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-14 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 3, 1, 3);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-15 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 3, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-16 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 2, 2, 3);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-17 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-18 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 3, 7, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-19 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 3, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-20 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 7, 2, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-21 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 2, 3, 4);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-22 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 12, 7, 2, 3);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-23 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 2, 1, 3);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-24 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 11, 6, 3, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-25 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-26 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 2, 3, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-27 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 7, 1, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-28 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 2, 2, 2);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-29 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 5, 3, 1);
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) VALUES (5, TO_TIMESTAMP('2024-03-30 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 2, 3, 5);

SELECT * FROM sleep WHERE time_stamp = TO_TIMESTAMP('2024-03-24 23:00:00', 'YYYY-MM-DD HH24:MI:SS');
-- Assuming you have already created the table Sleep and the trigger calculate_sleep_index_trigger

-- Inserting a record into the Sleep table
INSERT INTO Sleep (UserID, time_stamp, TotalDuration, Deep, Light, Rem) 
VALUES (1, TO_DATE('2024-03-01 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 2, 1);


SELECT * FROM Sleep WHERE time_stamp = TO_TIMESTAMP('2024-03-01 23:00:00', 'YYYY-MM-DD HH24:MI:SS');


-- Updating a record in the Sleep table
UPDATE Sleep 
SET TotalDuration = 7, Deep = 3, Light = 2, Rem = 2
WHERE UserID = 1 AND time_stamp = TO_TIMESTAMP('2024-03-01 23:00:00', 'YYYY-MM-DD HH24:MI:SS');


SELECT * FROM Sleep WHERE time_stamp = TO_TIMESTAMP('2024-03-01 23:00:00', 'YYYY-MM-DD HH24:MI:SS');
