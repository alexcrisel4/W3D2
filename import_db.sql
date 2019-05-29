DROP table if exists users;
Drop table if exists questions;
Drop table if exists replies;
Drop table if exists question_follows;
Drop table if exists question_likes;

PRAGMA foreign_keys = ON;


CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT,
  lname TEXT
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT,
  body TEXT,
  author_id INTEGER,

  FOREIGN KEY (author_id) references users(id)
);

CREATE TABLE question_follows
(
  user_id INTEGER,
  question_id INTEGER,

  FOREIGN KEY (user_id) references users(id)
  FOREIGN KEY (question_id) references questions(id)
);

CREATE TABLE replies
(
  id INTEGER PRIMARY KEY,
  subject_question INTEGER,
  parent_id INTEGER,
  user_id INTEGER,
  body TEXT,

  FOREIGN KEY (subject_question) references questions(id),
  FOREIGN KEY (parent_id) references replies(id),
  FOREIGN KEY (user_id) references users(id)
);

CREATE TABLE question_likes
(
  likes INTEGER,
  user_id INTEGER,
  question_id INTEGER,

  FOREIGN KEY (user_id) references users(id),
  FOREIGN KEY (question_id) references questions(id)
);


INSERT INTO users(fname, lname) 
VALUES('Percy', 'Dai'), ('Alexander', 'Crisel');

INSERT INTO questions(title, body, author_id)
VALUES('Why?', 'Waosdadfaierkjaoakwe', 1), ('What?', 'a;oeia;oiuhfawjbuadjiu', 2);

INSERT INTO replies(subject_question, parent_id, user_id, body)
VALUES(1, NULL, 1, 'LDladsfkjalsdfkjasdflaksdjflaksdjf');

INSERT INTO questions(title, body, author_id)
VALUES('Where?', 'aosirnoadf', 1);