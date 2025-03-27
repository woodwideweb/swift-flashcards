DROP TABLE IF EXISTS cards;
DROP TABLE IF EXISTS decks;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id UUID PRIMARY KEY,
  username TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE decks (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE (user_id, name)
);

CREATE TABLE cards (
  id UUID PRIMARY KEY,
  front TEXT NOT NULL,
  back TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  deck_id UUID NOT NULL REFERENCES decks(id) ON DELETE CASCADE
);

INSERT INTO users (id, username, password, created_at) VALUES ('9d307d61-246e-48c2-8b77-a67154b586f6', 'bob', 'hello123', NOW());

INSERT INTO decks (id, name, created_at, user_id) VALUES ('309cda4f-0b49-4f09-a582-13ef46b5c1ea', 'Basic phrases', NOW(), '9d307d61-246e-48c2-8b77-a67154b586f6'), ('9f758889-8749-45d5-9795-87524831c9ed', 'Something else', NOW(), '9d307d61-246e-48c2-8b77-a67154b586f6');

INSERT INTO cards (id, front, back, created_at, deck_id) VALUES ('6891b5a6-18d4-4297-9d8d-d89d8f9f8b4f', 'hola', 'hello', NOW(), '309cda4f-0b49-4f09-a582-13ef46b5c1ea'),
('c360f885-f1e0-4bdb-ad60-d6f3feece607', 'adios', 'goodbye', NOW(), '309cda4f-0b49-4f09-a582-13ef46b5c1ea'),
('d2a30118-e3c6-40fb-a767-b2b42306e3a8', 'gracias', 'thank you', NOW(), '9f758889-8749-45d5-9795-87524831c9ed');