DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS recipes;

-- Define your schema here:

CREATE TABLE recipes (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255),
  description VARCHAR(255)
);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  comment VARCHAR(255),
  recipe_id INT REFERENCES recipes(id)
);
