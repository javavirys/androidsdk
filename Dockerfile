FROM openjdk:8

MAINTAINER javavirys@gmail.com
USER root

ARG android_compile_sdk=29
ARG android_build_tools=29.0.3
ARG android_sdk_tools=4333796
ARG project_name=EspressoTest


ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-$android_sdk_tools.zip" \
    ANDROID_HOME="/usr/local/android-sdk" \
    ANDROID_VERSION=$android_compile_sdk \
    PROJECT_NAME=$project_name \
    ANDROID_BUILD_TOOLS_VERSION=$android_build_tools

ENV ANDROID_SDK=$ANDROID_HOME

RUN export PATH=$ANDROID_SDK/emulator:$ANDROID_SDK/tools:$ANDROID_SDK/tools/bin:$PATH

RUN apt-get update 

RUN apt-get -y install unzip
RUN apt-get -y install curl wget
RUN apt-get -y install software-properties-common
RUN apt-get -y install libgl1-mesa-glx

# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
    && cd "$ANDROID_HOME" \
    && curl -o sdk.zip $SDK_URL \
    && unzip sdk.zip \
    && rm sdk.zip \
    && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# Install Android Build Tool and Libraries
RUN $ANDROID_HOME/tools/bin/sdkmanager --update | grep -v = || true
RUN $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools" | grep -v = || true

RUN $ANDROID_HOME/tools/bin/sdkmanager emulator | grep -v = || true
RUN $ANDROID_HOME/tools/bin/sdkmanager "system-images;android-29;google_apis;x86" | grep -v = || true

RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

RUN $ANDROID_HOME/tools/bin/avdmanager create avd -n mynexus -k "system-images;android-29;google_apis;x86" --tag "google_apis" --device "Nexus 5"

RUN apt-get update && apt-get -y install android-tools-adb android-tools-fastboot

RUN mkdir -p "$PROJECT_NAME" \
    && cd "$PROJECT_NAME"

#ADD ./$PROJECT_NAME /$PROJECT_NAME/