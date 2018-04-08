Docker image with esp-open-sdk toolchain
=======

## Getting started

* building:

  ```
  git clone ...
  cd esp-opensdk-docker
  docker build -t 3mdeb/esp-open-sdk .
  ```

* running:

So far this container was used for building
[esp-open-rtos](https://github.com/SuperHouse/esp-open-rtos) projects

  ```
  git clone --recursive https://github.com/Superhouse/esp-open-rtos.git
  cd esp-open-rtos
  docker run -it --device=/dev/ttyUSB0 -v ${PWD}:/home/build \
      3mdeb/esp-open-sdk make flash -C examples/blink ESPPORT=/dev/ttyUSB0
  ```

  ```
  echo 'SUBSYSTEM =="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60" , MODE="0666"' \
  | sudo tee /etc/udev/rules.d/52-esp-serial.rules
  ```

In case of access errors such as:

  ```
  serial.serialutil.SerialException: [Errno 13] could not open port /dev/ttyUSB0: [Errno 13] Permission denied: '/dev/ttyUSB0'
  ../../common.mk:247: recipe for target 'flash' failed
  make: *** [flash] Error 1
  make: Leaving directory '/home/build/examples/blink'
  ```

Provide `udev` rules for your `tty` device, such as:

  ```
  echo 'SUBSYSTEM =="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60" , MODE="0666"' \
    | sudo tee /etc/udev/rules.d/52-esp-serial.rules
  ```

## TODO

* push to dockerhub
