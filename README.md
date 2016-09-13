<h3 align="center">
  <img src="assets/logo.png" alt="walle"/>
</h3>

# walle

A simple Android build system.  
It can create an Android project, compile it, create APK package and install the package to an active emulator.  
This is just an experiment to create a custom build system. It is not better than existing build systems in any way.  
**If you are looking for a build system to use in production, [Gradle](https://gradle.org) is, probably, a good fit.**

[![Build Status](https://travis-ci.org/thelvis4/walle.svg?branch=master)](https://travis-ci.org/thelvis4/walle)

============

## Requirements

- [Android SDK](https://developer.android.com/studio/index.html)
- ruby ~> 1.9.3
- bundler ~> 1.13
- rake ~> 10.4

## Installation

Clone the source and cd into the project directory.

    $ git clone https://github.com/thelvis4/walle.git
    $ cd walle

Then build and install the gem:

    $ bundle; rake install


## Usage

### Prerequisites

##### ANDROID_HOME

`ANDROID_HOME` environment variable is used in order to find Android SDK tools.  
Set `ANDROID_HOME` using:
  
    $ export ANDROID_HOME=</path/to/Android/sdk>

where `</path/to/Android/sdk>` is the path to Android SDK on your machine.

##### JAVA_HOME

Setting `JAVA_HOME` environment variable is not mandatory, but recommended.  
You can set it using:

    $ export JAVA_HOME=</path/to/java>



**The complete list of options can be seen running `walle --help`.**

### Create
To create an Android project:

    $ walle create --name MyProject

### Compile
To compile project's sources:

    $ cd MyProject
    
    $ walle compile

### [Pack](https://youtu.be/9XYvIH4TgKE)
To create APK package:

    $ walle pack

### Deploy
To install the app on Android emulator:

    $ walle deploy

*This will require an Android emulator to be active.


### Build configuration file
To do his job, `walle` uses a build configuration file (`build.walle`) located in project's root folder.  
It defines the project name and the company domain. If you use `create` command, `build.walle` file is generated automatically.  
You can also set custom shell scripts that will run before and/or after each build phase (compile, pack, deploy).  
Here is an example of build configuration file:
```JSON
{
    "name" : "test",
    "company_domain" : "com.company",
    
    "scripts" : {
        "compile" : {
            "before" : "echo 'Start compiling'",
            "after" : "echo 'Finished compiling.'"
        },
        "pack" : {
            "after" : "echo 'The package was created'"
        }
    }
}

```

`build.walle` is a JSON file and you can modify its contents using a text editor.


## Limitations

Due to a rought version of this product, there a couple of limitations:
* Each of build phases depends on the output of the previous command. If changes were made in source code, deploying the new version of the app will require to run `compile`, `pack`, `deploy` in this order.

* Before deploying, make sure you have a Android Virtual Device (AVD) created and a instance of Android emulator is active.
You can list current AVDs using `android list avd` and the list of devices attached using `adb devices`.


## Tests

    $ rake

    ..........

    Finished in 0.01559 seconds (files took 0.15425 seconds to load)
    10 examples, 0 failures


## Credits

The logo is inspired by mattcantdraw's [Alternative Android Logos](http://mattcantdraw.deviantart.com/art/Alternative-Android-Logos-345898996).


## License

MIT Licensed.
