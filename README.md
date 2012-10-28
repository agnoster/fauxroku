# fauxroku

> STATUS: Prototype

Deploy heroku-style apps to ec2 with minimal fuss.

Working with nodejs apps. Currently builds the app, but does not do deployment yet.

## dependencies

* ubuntu box
* foreman
* libssl0.9.8 (for nodejs)

## assumptions

* This code is installed in `/var/fauxroku/deploy`.
* Heroku buildpacks available in `/var/fauxroku/buildpacks`.
* Bare repos installed in `$HOME`
* Apps get deployed to `/var/fauxroku/apps/$APPNAME/$GIT_HASH`

## how to use

    ./create-app $APP # creates a new bare repo with appropriate git hooks
    ./deploy-app $APP $GIT_HASH # manually deploy $APP at revision $GIT_HASH

## mit license
