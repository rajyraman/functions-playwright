################################################
# Compile with:
#     sudo docker build -t microsoft/playwright:bionic -f Dockerfile.bionic .
#
# Run with:
#     sudo docker run -d -p --rm --name playwright microsoft/playwright:bionic
#
#################################################

FROM ubuntu:bionic

ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true

# 1. Install node12
RUN apt-get update && apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -y nodejs

# 2. Install WebKit dependencies
RUN apt-get install -y libwoff1 \
                       libopus0 \
                       libwebp6 \
                       libwebpdemux2 \
                       libenchant1c2a \
                       libgudev-1.0-0 \
                       libsecret-1-0 \
                       libhyphen0 \
                       libgdk-pixbuf2.0-0 \
                       libegl1 \
                       libnotify4 \
                       libxslt1.1 \
                       libevent-2.1-6 \
                       libgles2 \
                       libvpx5

# 3. Install Chromium dependencies

RUN apt-get install -y libnss3 \
                       libxss1 \
                       libasound2

# 4. Install Firefox dependencies

RUN apt-get install -y libdbus-glib-1-2

# 5. Add user so we don't need --no-sandbox in Chromium
RUN groupadd -r pwuser && useradd -r -g pwuser -G audio,video pwuser \
    && mkdir -p /home/pwuser/Downloads \
    && chown -R pwuser:pwuser /home/pwuser

# Run everything after as non-privileged user.
USER pwuser

COPY . /home/site/wwwroot

RUN cd /home/site/wwwroot && \
    npm install