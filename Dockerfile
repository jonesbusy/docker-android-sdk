FROM gradle:4.10.2-jdk8-slim

# Build arg
ARG android_sdk_version=4333796
ARG download_server=https://dl.google.com/android/repository
ENV ANDROID_SDK_VERSION ${android_sdk_version}

# Prepare environment
USER root
RUN mkdir -p /opt/android-sdk && chown -R gradle:gradle /opt/android-sdk
WORKDIR /opt/android-sdk

# Install android sdk
RUN wget -q ${download_server}/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip && \
    unzip *tools*linux*.zip && \
    rm *tools*linux*.zip

# Set environment
ENV ANDROID_HOME /opt/android-sdk
ENV PATH ${PATH}:${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/bin

# Update sdk manager
RUN mkdir ~/.android/ && touch ~/.android/repositories.cfg && sdkmanager --update

# Accept all license
RUN yes | sdkmanager --licenses

# Install emulator and tools
RUN sdkmanager "tools" "emulator" "platform-tools" "emulator"

RUN sdkmanager "extras;android;m2repository" "extras;google;m2repository" "extras;google;simulators" "extras;google;webdriver" "extras;google;market_licensing" "extras;google;market_apk_expansion"
