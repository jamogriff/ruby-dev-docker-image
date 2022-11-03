FROM ruby:3.1.1-alpine

# ------------ Root Related Stuff ------------
# User config and creation
ARG username=ruby
ARG user_id=700
RUN adduser -u $user_id -D $username
WORKDIR /home/${username}/dev
COPY . ./
RUN chown -R ${username}:${username} /home/${username}

# Install package dependencies
RUN apk update && apk add git curl zsh build-base # build-base needed for gcc compilation
RUN apk add --update npm && npm install --global yarn && corepack enable && corepack prepare yarn@3.2.4 --activate # enables corepack for yarn v3+

# ------------ User Related Stuff -----------
USER $username
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN yarn init -2

# Ruby env configuration
ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH
# Unset these to allow for calling Gem bin's directly
RUN unset BUNDLE_PATH && unset BUNDLE_BIN
RUN bundle install