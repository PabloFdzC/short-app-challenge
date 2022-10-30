# Shortening algorithm

    Since the url needs to be as short as possible and relative to the
    number of links in the system I thought that it was a good idea to:
    1) Count the number of links that are already stored and the number of
    characters in CHARACTERS list
    2) Select each character of the code by using modulo operation on the
    number of links already stored and the number of characters in the CHARACTERS
    list with this operation we get the position of the character need to be used
    so that we can concatenate it to the new short_code
    3) Repeat (2) and after every concatenation reduce the number of records
    dividing it by the number of characters and subtracting 1 to that, this process
    is repeated until the number of links reaches 0 

# Intial Setup

    docker-compose build
    docker-compose up mariadb
    # Once mariadb says it's ready for connections, you can use ctrl + c to stop it
    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml build

# To run migrations

    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml run short-app-rspec rails db:test:prepare

# To run the specs

    docker-compose -f docker-compose-test.yml run short-app-rspec

# Run the web server

    docker-compose up

# Adding a URL

    curl -X POST -d "full_url=https://google.com" http://localhost:3000/short_urls.json

# Getting the top 100

    curl localhost:3000

# Checking your short URL redirect

    curl -I localhost:3000/abc
