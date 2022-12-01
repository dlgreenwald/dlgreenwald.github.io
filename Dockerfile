# using ruby:latest
# naming this stage as jekyll-build
FROM ruby as jekyll-build

# Install bundler gem
RUN gem install bundler

# Set the working directory for subsequent
# RUN, CMD, ADD, COPY and ENTRYPOINT commands
WORKDIR /work

# Copy Gemfile into /work and run bundle install
# to install the required dependencies
COPY Gemfile* /work/
RUN bundle install

# Copy the root contents into /work
COPY . .

# Set necessary environment variables for the build
# and fire off the build
ENV JEKYLL_ENV=production
RUN bundle exec jekyll build

# Now that _site is built in /work directory, take it from
# jekyll-build stage and put it into /usr/share/nginx/html
# of the nginx image
FROM nginx
COPY --from=jekyll-build  /work/_site /usr/share/nginx/html
COPY _app/etc/nginx/default.conf /etc/nginx/conf.d/default.conf
