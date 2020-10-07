FROM ruby:2.6.6-alpine

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# root of project
WORKDIR /usr/src/app

# additional packages needed for 'bundle install'
RUN set -eux; \
	apk add --no-cache --virtual .ruby-builddeps \
		bash \
		cmake \
		build-base \
		linux-headers \
		git \
		postgresql-dev \
		nodejs \
		yarn \
		tzdata \
		graphviz \
		gmp-dev \
	;

# copy Gemfile and Gemfile.lock for project specific gems
COPY Gemfile Gemfile.lock ./

# install all required gems
RUN bundle install

# copy everything else into /usr/src/app
COPY . .

# clone the community samples
RUN git clone https://github.com/TIBCOSoftware/tibco-streaming-community.git;

# run the tests
CMD [ "sh", "lib/test.sh" ]
