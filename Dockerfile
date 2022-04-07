FROM ruby:3.1.1-alpine

# ------------ Root Related Stuff ------------
# User config and creation
ARG username=zing
ARG user_id=1000
RUN adduser -u $user_id -D $username
WORKDIR /home/${username}/shopify-dev
COPY . ./
RUN chown -R ${username}:${username} /home/${username}

# Install package dependencies
RUN apk update && apk add git curl zsh build-base # build-base needed for gcc compilation
RUN apk add --update npm && npm install --global yarn && corepack enable # enalbes corepack for yarn v3+

# ------------ User Related Stuff -----------
USER $username
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Ruby env configuration
ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH
# Unset these to allow for calling Gem bin's directly
RUN unset BUNDLE_PATH && unset BUNDLE_BIN
RUN bundle install

# Quality of Life for opening Shopify CLI
RUN mkdir -p ~/.config/shopify && printf "[analytics]\nenabled = false\n" > ~/.config/shopify/config

# ------------ Ports ---------------
# Shopify OAuth flow needs port 3456 open to authenticate via Shopify CLI
EXPOSE 3456
# Shopify serves themes on port 9292
EXPOSE 9292
