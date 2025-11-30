# Sinlog

A very, very simple Ruby singleton logger with colored log levels.

> Singleton means that the entire program will share the same instance (logger).

[![Gem Version](https://badge.fury.io/rb/sinlog.svg?icon=si%3Arubygems)](https://rubygems.org/gems/sinlog)
<!-- [![RubyDoc](https://img.shields.io/badge/-y?label=rubydoc&color=orange)](https://www.rubydoc.info/gems/sinlog) -->

---

| Language/語言                   | ID         |
| ------------------------------- | ---------- |
| English                         | en-Latn-US |
| [简体中文](./Readme-zh.md)      | zh-Hans-CN |
| [繁體中文](./Readme-zh-Hant.md) | zh-Hant-TW |

---

<details>
<summary>
Table of Contents (click to expand)
</summary>

- [Quick Start](#quick-start)
- [Installation](#installation)
  - [Comparison Table (Monkey Patching)](#comparison-table-monkey-patching)
  - [Method List](#method-list)
    - [Mixin \& Refin](#mixin--refin)
    - [ShortMixin \& ShortRefin](#shortmixin--shortrefin)
  - [Examples](#examples)
    - [Classic Method Call (Neither Mixin nor Refinement)](#classic-method-call-neither-mixin-nor-refinement)
    - [Refinement](#refinement)
    - [Mixin](#mixin)
- [Learn Sinlog API by Example](#learn-sinlog-api-by-example)
  - [Classic Method Call](#classic-method-call)
- [Advanced](#advanced)
  - [Real World Example](#real-world-example)
  - [Log Levels](#log-levels)
  - [Environment Variables](#environment-variables)
  - [Log Output Device/Path](#log-output-devicepath)
  - [Other Logger Methods](#other-logger-methods)
  - [Notes](#notes)
- [Side Note](#side-note)
- [Changelog](#changelog)
  - [0.0.3](#003)
  - [0.0.6](#006)
- [License](#license)

</details>

## Quick Start

## Installation

```sh
# POSIX-sh
#
gem install sinlog
```

### Comparison Table (Monkey Patching)

| Module     | Type       | Activation | Method Naming                                            |
| ---------- | ---------- | ---------- | -------------------------------------------------------- |
| Mixin      | Mixin      | include    | log_dbg, log_info, log_warn, log_err, log_fatal, log_unk |
| Refin      | Refinement | using      | log_dbg, log_info, log_warn, log_err, log_fatal, log_unk |
| ShortMixin | Mixin      | include    | dbg, info, warn, err, fatal, unk                         |
| ShortRefin | Refinement | using      | dbg, info, warn, err, fatal, unk                         |

### Method List

#### Mixin & Refin

- `log_dbg`   – DEBUG
- `log_info`  – INFO
- `log_warn`  – WARN
- `log_err`   – ERROR
- `log_fatal` – FATAL
- `log_unk`   – UNKNOWN

#### ShortMixin & ShortRefin


- **ShortRefin** is similar to **Refin**
  - Apart from the difference in method naming, their internal implementations are identical.
    - Methods in **Refin** have the `log_` prefix
    - **ShortRefin** does not

- **ShortMixin** is similar to **Mixin**
  - The only difference is in naming
    - Methods in **Mixin** have the `log_` prefix
    - **ShortMixin** does not

---

- `dbg`   – DEBUG
- `info`  – INFO
- `warn`  – WARN
- `err`   – ERROR
- `fatal` – FATAL
- `unk`   – UNKNOWN

> ⚠️ Since **ShortMixin** and **ShortRefin** define a `warn` method, they will override the default `warn`.
> For Ruby code that uses `warn "msg"` (which outputs to **stderr** rather than using a log format), you may need to manually change it to `Kernel.warn "msg"`.
>
> If this bothers you, then use `using Sinlog::Refin` instead of `using Sinlog::ShortRefin`.

### Examples

#### Classic Method Call (Neither Mixin nor Refinement)

```ruby
require 'sinlog'

log = Sinlog.logger
log.info "Information"
log.debug "This is a debug message"
```

#### Refinement

```ruby
require 'sinlog'
using Sinlog::Refin
{ dir: "/path/to/xx" }.log_info
```

```ruby
require 'sinlog'
using Sinlog::ShortRefin
{ dir: "/path/to/xx" }.info
```

#### Mixin

```ruby
require 'sinlog'
include Sinlog::Mixin
"Hello".log_info
```

```ruby
require 'sinlog'
include Sinlog::ShortMixin
"Hello".info
```

## Learn Sinlog API by Example

<img src="../assets/img/preview.webp" alt="preview">

```ruby
require 'sinlog'

module A
  module_function
  using Sinlog::ShortRefin

  def log
    ['Hey hey hey, could you see this debug message?',
     'You might find it a bit verbose, hahaha!'].dbg
    'Just some info.'.info

    'FBI, open the door!'.warn
    { error: "IO", type: "InvalidData" }.err
    'Error occurred, continuing may break things.'.err
    'Bzzzz... it is bro...ken...nnn~'.fatal
  end
end

A.log

# update the log level to error
Sinlog.logger(level: 'err')
Kernel.warn 'Logger.level => error'
A.log
```

### Classic Method Call

If you prefer the traditional style (`log.info(msg)` instead of `msg.info`):

```ruby
require 'sinlog'

ENV["CUSTOM_LOG"] = 'info'

log = Sinlog.logger(env_name: "CUSTOM_LOG")

log.debug 'debug'
log.info 'information'
log.warn 'warning'
log.error 'error'
log.fatal 'fatal'
log.unknown 'unknown'
```

> The data type of `Sinlog.logger` is Ruby’s standard library `Logger`.

In addition to the common methods listed above, you can also use other methods such as `.reopen`.
For details, see <https://docs.ruby-lang.org/en/3.4/Logger.html>

  - `debug`
  - `info`
  - `warn`
  - `error`
  - `fatal`
  - `unknown`

## Advanced

After trying it out ourselves, we have a basic understanding of `sinlog`.
In most cases, knowing its basic usage is sufficient.

If you're interested, let's continue exploring together.

### Real World Example

In the real world, our program might look like this:

```ruby
require 'sinlog'

class EpubProcessor
  def initialize(epub_file, logger = nil)
    @epub = epub_file
    logger ||= Sinlog::logger(env_name: "XX_LOG")
    @logger = logger
    @logger.debug "EpubProcessor class initialization completed."
  end
end
```

We might define a class's `@logger` instance variable and allow for a custom logger.

Simply put, we might configure the logger more finely.

In the following content, we will explore how to perform "more fine-grained configuration."

### Log Levels

Log levels from low to high are:

- debug = 0
- info = 1
- warn = 2
- error = 3
- fatal = 4
- unknown = 5

> Interestingly, the log levels in Ruby’s standard library `Logger` are the opposite of Rust’s [log::Level](https://docs.rs/log/latest/log/enum.Level.html).

```ruby
p Sinlog::LV
# => {debug: 0, info: 1, warn: 2, error: 3, fatal: 4, unknown: 5}

# Change the log level to warn
log = Sinlog.logger(level: 'warn')
# OR:
#   log = Sinlog.logger(level: Sinlog::LV[:warn])
# OR:
#   log = Sinlog.logger.tap { it.level = 2 }

log.error "This message will be displayed! Lower level WARN (2) will display higher level ERROR (3) logs."
log.info "This message will not be displayed! Higher level WARN (2) will not display lower level INFO (1) logs."
```

- The lower the log level, the more detailed the content displayed.
- Lower levels **will** display higher level logs.
- Higher levels **will not** display lower level logs.

### Environment Variables

In the real world, for client applications, the end users are typically regular users.
To allow them to configure `log.level` directly, we can use environment variables.

> Using environment variables is simple and efficient.

By default, `Sinlog::Logger` will attempt to read the value of the environment variable `RUBY_LOG`.

- If the environment variable does not exist, it uses `debug(0)`.
- If the environment variable exists but is empty, it uses `error(3)`.
- If the environment variable's value is invalid, it uses `error(3)`.

We can set the environment variable using POSIX-sh, and then the logger will automatically set the log level to `warn` (the value of `RUBY_LOG`) during initialization.

```sh
# Possible values: debug, info, warn, error, fatal
export RUBY_LOG=warn
```

If you don't want to use the default `RUBY_LOG` environment variable and prefer to use the value of `XX_CLI_LOG`, you can do it like this:

POSIX-sh:

```sh
export XX_CLI_LOG=info
```

Ruby:

```ruby
logger = Sinlog.logger(env_name:"XX_CLI_LOG")

logger.debug "This message will not be displayed because the current log level is INFO(1)."
logger.info "Hello!"
```

### Log Output Device/Path

By default, Sinlog outputs to `STDERR`.

If you need to customize the log output path, you can call the Logger's `reopen` method.

```ruby
# Logs will be output to the file a.log
log = Sinlog.logger.tap { it.reopen("a.log") }

log.error "What happened! QuQ"
```

OR:

```ruby
log = Sinlog.logger
log.reopen("a.log")

log.error "What happened! QuQ"
```

### Other Logger Methods

In addition to `.reopen` and `.level`, we can also call other methods from Ruby's standard library logger on `Sinlog.logger`.

### Notes

`Sinlog::Logger` uses the Singleton pattern, meaning the entire program will share the same instance (logger).

Modifying `Sinlog.logger` (a.k.a. `Sinlog::Logger.instance.logger`) in class A of the same program will affect `Sinlog::Logger` in class B.

## Side Note

This is the first Ruby gem I have released.
The API might not fully adhere to idiomatic Ruby usage, so I appreciate your understanding.

## Changelog

### 0.0.3

- `Sinlog.instance.logger` can be simplified => `Sinlog.logger`

- add `Sinlog.logger_with_level`
  - e.g., `logger = Sinlog.logger_with_level(Sinlog::LV[:warn])`
  - old: `Sinlog.instance.logger.tap { it.level = Sinlog::LV[:warn] }`

- add `LogExt`, `LogShortExt` and `Loggable`

- add sorbet **.rbi** files

Breaking changes:
- `fetch_env_and_update_log_level(ENV_NAME)` => `set_level_from_env!(ENV_NAME)`
- remove `LogLambdaExt` and related modules

### 0.0.6

- add `Sinlog::ShortMixin` module
- reimplement `Sinlog.logger` to make the API more user-friendly.
    - We can now configure the log level via `Sinlog.logger(level: "info", env_name: "CUSTOM_ENV_LOG")`.
    - **Note:** When both `level` and `env_name` are provided, `level` takes precedence.

Breaking changes:

- `using LogExt` => `using Sinlog::Refin`
- `using LogShortExt` => `using Sinlog::ShortRefin`
- `include Loggable` => `include Sinlog::Mixin`
- `Sinlog` class => `Sinlog` module
  - private method: `Sinlog.initialize` => `Sinlog::Logger.initialize`
- remove `Sinlog.logger_with_level`
- change the default fallback log level from "unknown(5)" to "error(3)"

## License

[MIT License](../License)
