DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL, 
  user_id INTEGER NOT NULL, 

  FOREIGN KEY (user_id)  REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows(
  id  INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL, 
  user_id INTEGER NOT NULL,
  
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER, 
  user_id INTEGER NOT NULL,
  content TEXT NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id  INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL, 
  user_id INTEGER NOT NULL,
  
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);


INSERT INTO 
  users (fname, lname)
VALUES 
  ('Tina', 'Johnson'),  
  ('Paul', 'Thomas'),
  ('Felix', 'Thecat'),
  ('Charlie', 'Brown'),
  ('Samantha', 'Turner');
  
  
INSERT INTO 
  questions (title, body, user_id)
VALUES 
  ('Q1', 'Who?', 1),
  ('Q2', 'What?', 3),
  ('Q3', 'Where?', 1),
  ('Q4', 'When?', 5),
  ('Q5', 'Why?', 4),
  ('Q6', 'How?', 2),
  ('Q7', 'WTF?!', 3);
  
INSERT INTO 
  question_follows (question_id, user_id)
VALUES
  (1,1),
  (1,2),
  (2,3);
  
INSERT INTO 
  replies (question_id, parent_reply_id, user_id, content)
VALUES
  ( 1, NULL , 1 , 'I don''t know' ),
  ( 3 , NULL , 4 , 'App Academy' ),
  ( 3 , 2 , 3 , 'of course in fidi' ),
  ( 7 , NULL , 5 , 'that is not nice' );

  INSERT INTO 
    question_likes (question_id, user_id)
  VALUES
    (1,4),
    (2,1),
    (3,2);

  
