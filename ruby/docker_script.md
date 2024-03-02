### Posgres docker

docker run --rm --name rblabs-postgres -e POSTGRES_PASSWORD=123456 -e POSTGRES_USER=postgres -d -p 127.0.0.1:5432:5432 --network rblabs-network postgres

### Ruby docker

docker run --rm -v .:/app -it -w /app -p 127.0.0.1:3000:3000 --network rblabs-network ruby bash -c "bundle install && ruby import_from_csv.rb && ruby server.rb puma -o 0.0.0.0 -p 3000"
