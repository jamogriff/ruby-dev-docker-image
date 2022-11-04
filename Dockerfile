FROM ruby:3.1.1-alpine

# ------------ Root Related Stuff ------------
# User config and creation
ENV LANG=C.UTF-8
ARG username=ruby
ARG user_id=700
RUN adduser -u $user_id -D $username
WORKDIR /home/${username}/dev

# Install updated package dependencies
RUN apk update && apk add neovim git curl zsh build-base # build-base needed for gcc compilation
RUN apk add --update npm && npm install --global yarn && corepack enable && corepack prepare yarn@3.2.4 --activate # enables corepack for yarn v3+
RUN gem update --system && gem install bundler

# Set ownership of work dir to ruby user
RUN chown -R ${username}:${username} /home/${username}
# Set ownership of bundle directory to ruby user-- not sure if this is kosher but it works
RUN chown -R ${username}:${username} /usr/local/bundle

# ------------ User Related Stuff -----------
USER $username
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

CMD ["/bin/zsh"]
