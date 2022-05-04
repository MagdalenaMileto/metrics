# metrics
Hello! 👋

These are the steps to get the application up and running:

1. Clone the repository using the command:
```
HTTPS: https://github.com/MagdalenaMileto/metrics.git
SSH: git@github.com:MagdalenaMileto/metrics.git
```

2. Install dependencies
```
# on /backend
bundle install

# on /frontend
npm install
```

**For the following steps make sure you have ports 3000, 3001 and 5432 free!**

3. Start DB:
```
docker run  -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres
```

4. Prepare DB and run migrations:
```
 # on /backend
 rails db:create db:migrate
 rails db:seed
```

5. Run rails application:
```
# on /backend
rails s
```

6. Run vite aplication:
```
# on /frontend
npm run dev
```

7. Now you can visit the site with the URL http://localhost:3001


# next setps:
- Metric average pagination
- Handle missing values on timescale
- Prettier dates
- Frontend tests
