require 'pg'
require 'faker'
require 'pry'

TITLES = ["Roasted Brussels Sprouts",
  "Fresh Brussels Sprouts Soup",
  "Brussels Sprouts with Toasted Breadcrumbs, Parmesan, and Lemon",
  "Cheesy Maple Roasted Brussels Sprouts and Broccoli with Dried Cherries",
  "Hot Cheesy Roasted Brussels Sprout Dip",
  "Pomegranate Roasted Brussels Sprouts with Red Grapes and Farro",
  "Roasted Brussels Sprout and Red Potato Salad",
  "Smoky Buttered Brussels Sprouts",
  "Sweet and Spicy Roasted Brussels Sprouts",
  "Smoky Buttered Brussels Sprouts",
  "Brussels Sprouts and Egg Salad with Hazelnuts"]

#WRITE CODE TO SEED YOUR DATABASE AND TABLES HERE
def db_connection
  begin
    connection = PG.connect(dbname: "brussels_sprouts_recipes")
    yield(connection)
  ensure
    connection.close
  end
end


db_connection do |conn|
  TITLES.each do |title|
    conn.exec("INSERT INTO recipes(title, description) VALUES ('#{title}', '#{Faker::Lorem.sentence}')")
  end

  20.times do
    rand_num = rand(1..11)
    conn.exec("INSERT INTO comments(comment, recipe_id) VALUES ('#{Faker::Lorem.word}', #{rand_num})")
  end
end

recipes = db_connection { |conn| conn.exec("SELECT * FROM recipes") }
comments = db_connection { |conn| conn.exec("SELECT * FROM comments") }

# How many recipes are there in total?
puts "There are #{recipes.to_a.length} recipes in total"
# How many comments are there in total?
puts "There are #{comments.to_a.length} comments in total"
# How would you find out how many comments each of the recipes have?
recipes.each do |recipe|
  recipe_comments = db_connection { |conn| conn.exec("SELECT * FROM comments WHERE recipe_id = #{recipe["id"]}") }
  if recipe_comments
    puts "#{recipe["title"]} has #{recipe_comments.to_a.length} comments"
  else
    puts "#{recipe["title"]} has 0 comments"
  end
end
# What is the name of the recipe that is associated with a specific comment?
puts "#{comments[3]["comment"]} is associated with #{recipes[comments[3]["recipe_id"].to_i - 1]["title"]}"
# Add a new recipe titled Brussels Sprouts with Goat Cheese. Add two comments to it.
db_connection { |conn|
  conn.exec("INSERT INTO recipes(title, description) VALUES ('Brussels Sprouts with Goat Cheese', 'Its really good!')")
  recipe_id = conn.exec("SELECT id FROM recipes WHERE title = 'Brussels Sprouts with Goat Cheese'")
  conn.exec("INSERT INTO comments(comment, recipe_id) VALUES ('The best recipe ever', #{recipe_id[0]["id"]}), ('The worst recipe ever', #{recipe_id[0]["id"]})")
}
