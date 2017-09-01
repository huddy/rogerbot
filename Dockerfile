FROM node:6.2.0

RUN mkdir /opt/bot \
    && useradd -ms /bin/bash node \
    && chown -R node /opt/bot

ENV HUBOT_VERSION 2.19.0
ENV BOT_NAME "rogerbot"
ENV EXTERNAL_SCRIPTS=hubot-diagnostics,hubot-help,hubot-google-images,hubot-google-translate,hubot-pugme,hubot-maps,hubot-rules,hubot-shipit,hubot-speed-test

RUN npm install -g \
    hubot@${HUBOT_VERSION} \
    yo@1.7.0 \
    generator-hubot@0.3.1

USER root 
WORKDIR /opt/bot

ADD bot /opt/bot

RUN npm install 

CMD node -e "console.log(JSON.stringify('$EXTERNAL_SCRIPTS'.split(',')))" > external-scripts.json && \
	npm install $(node -e "console.log('$EXTERNAL_SCRIPTS'.split(',').join(' '))") && \
	bin/hubot -n $BOT_NAME -a slack 