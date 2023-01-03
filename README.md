# XCTestPlanner
A tool for managing [Xcode Test Plans](https://medium.com/trendyol-tech/get-the-most-out-of-ui-tests-with-xcode-test-plans-d089a2252ba2) from command line.

## Why?
Test plans are a valuable tool for organizing and managing your tests in Xcode projects. \
However, manually editing large number of test plans can be time-consuming and tedious (sometimes crashy). \

And also, It's not possible to selectively run or skip specific test classes with a test plan.


## Features
XCTestPlanner simplifies to edit test plans by providing command-line interface for adding or removing tests, setting language and region options, and adjusting the rerun numbers.

- Handle your test plans from command line interface instead of Xcode.
- Simplify your CI setups by creating a single test plan that can be customized for various configurations.
- Easily adjust the number of test repetitions for different environments.
- Control the Localizations by passing parameters.
- Conveniently set environment variables/ arguments for your CI pipelines.


## Installation
### [Mint](https://github.com/yonaskolb/mint)
```
brew install mint
mint install atakankarsli/xctestplanner
```
or clone the repo and run `swift build --configuration release` command. You will find xctestplanner executable in `.build/release` directory
You need to copy it copy it to the /usr/local/bin directory, allowing you to run without the need to specify swift run."
```
cp -f .build/release/xctestplanner /usr/local/bin/xctestplanner
```

## Usage
To use xctestplanner, you will need to follow these steps:

1. Create a test plan in your Xcode project.
2. Add at least one test target to the test plan.
3. Run the xctestplanner command and pass the path to the test plan file and any necessary options.
4. The tool will modify the test plan according to the provided options and save the changes to the file.

After these step you'll have example.xctestplan look like this:

### Example Test Plan JSON:
```json
{
    "configurations": [
        {
            "name": "Configuration 1",
            "options": {
                "targetForVariableExpansion": {
                    "name": "TestTarget"
                }
            }
        }
    ],
    "defaultOptions": {
        "commandLineArgumentEntries": [
            {
                "argument": "ARGUMENT_NAME"
            }
        ],
        "environmentVariableEntries": [
            {
                "key": "VAR_KEY_1",
                "value": "$(VAR_VALUE_1)"
            }
        ],
        "language": "en",
        "maximumTestRepetitions": 2,
        "region": "US",
        "testRepetitionMode": "retryOnFailure",
        "testTimeoutsEnabled": true
    },
    "testTargets": [
        {
            "parallelizable": true,
            "skippedTests": [
                "TestClass",
                "TestClass\/TestName()"
            ],
            "target": {
                "name": "TestTarget"
            }
        }
    ],
    "version": 1
}
```

There are two main commands for selecting tests in a test plan: `select` and `skip`. \
To add tests to the list of selected tests, use the `select` command. If the `Automatically include new tests` option is enabled in your test plan, you should use the `skip` command to exclude more tests from being run. 

<img width="585" alt="SCR-20221223-wuy-2" src="https://user-images.githubusercontent.com/10248517/209411298-ebda2283-d5d2-4e7c-9ec0-fe971173d0b1.png">

For all commands you need to provide the path to the JSON file containing the test plan using the -f or --filePath option

### Select / Skip
To update the list of selected/skipped tests in a test plan, use the select command and pass the path to the test plan file and a list of test names:

```
xctestplanner select TestClass1 TestClass2 -f path/to/testplan.xctestplan
```
Or
```
xctestplanner skip TestClass1 TestClass2 -f path/to/testplan.xctestplan
```

By default, the select/skip commands will add the specified tests to the existing list of selected/skipped tests. \
If you want to selectively run or skip only specified test classes use `--override` or the `-o` flag:
```
xctestplanner select TestClass1 TestClass2 -o -f filePath
```

And you can set the language, region and adjust rerun count with using the `--language` and `--region`, `--rerun` flags:

```
xctestplanner select TestClass1 TestClass2 -f filePath -o --language en --region US --rerun 3
```

### Rerun
You can adjust these without adding/removing tests with the these commands, you will need to provide --rerun option.

```
xctestplanner rerun 3 -f filePath
```

### Language
```
xctestplanner language en -f filePath
```

### Region
```
xctestplanner region EN -f filePath
```

### Argument
The key of the command line argument to set using the --key option. If you want to disable the specified command line argument, use the `-d` or `--disabled` flag.

```
xctestplanner argument -f filePath --key DEV_CONFIG --disabled
```

### Environment Variable
The key and value of the environment variable using the `--key` and `--value` options, respectively.

```
xctestplanner environment -f filePath --key MY_VAR --value 123
```


## Contribution

Please create an issue whenever you find an issue or think a feature could be a good addition to XCTestPlanner. 

## License

XCTestPlanner is [available under the Apache License 2.0](https://github.com/atakankarsli/xctestplanner/blob/main/LICENSE).
