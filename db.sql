DROP TABLE IF EXISTS cards;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id UUID PRIMARY KEY,
  username TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE cards (
  id UUID PRIMARY KEY,
  front TEXT NOT NULL,
  back TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO users (id, username, password, created_at) VALUES ('9d307d61-246e-48c2-8b77-a67154b586f6', 'bob', 'hello123', NOW());

INSERT INTO cards (id, front, back, created_at, user_id) VALUES ('6891b5a6-18d4-4297-9d8d-d89d8f9f8b4f', 'hola', 'hello', NOW(), '9d307d61-246e-48c2-8b77-a67154b586f6');