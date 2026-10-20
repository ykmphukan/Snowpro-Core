CREATE OR REPLACE STREAM COMPANY.PUBLIC.TITANIC_STREAM ON TABLE COMPANY.PUBLIC.TITANIC
  SHOW_INITIAL_ROWS = FALSE;

SELECT * FROM COMPANY.PUBLIC.TITANIC;
  SELECT * FROM COMPANY.PUBLIC.TITANIC_STREAM;

  INSERT INTO COMPANY.PUBLIC.TITANIC (
    PassengerId,
    Survived,
    Pclass,
    Name,
    Sex,
    Age,
    SibSp,
    Parch,
    Ticket,
    Fare,
    Cabin,
    Embarked
  )
  VALUES (
    1,
    0,
    3,
    'Braund, Mr. Owen Harris',
    'male',
    22.0,
    1,
    0,
    'A/5 21171',
    7.2500,
    NULL,
    'S'
  );

  -- TASK

  CREATE TABLE COMPANY.PUBLIC.TITANIC_FINAL AS
  (SELECT * FROM COMPANY.PUBLIC.TITANIC LIMIT 0);

  CREATE OR REPLACE TASK TITANIC_DATA_REFRESH_TASK
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = '1 MINUTE'
  WHEN SYSTEM$STREAM_HAS_DATA('TITANIC_STREAM')
AS
  INSERT INTO TITANIC_FINAL (
    PassengerId, Survived, Pclass, Name, Sex, Age,
    SibSp, Parch, Ticket, Fare, Cabin, Embarked
  )
  SELECT
    PassengerId, Survived, Pclass, Name, Sex, Age,
    SibSp, Parch, Ticket, Fare, Cabin, Embarked
  FROM TITANIC_STREAM
  WHERE METADATA$ACTION = 'INSERT';

  ALTER TASK TITANIC_DATA_REFRESH_TASK RESUME;

  show tasks;