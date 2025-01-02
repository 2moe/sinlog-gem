# Sinlog

A very, very simple Ruby singleton logger with colored log levels.

> Singleton means that the entire program will share the same instance (logger).

---

| Language/語言                   | ID         |
| ------------------------------- | ---------- |
| English                         | en-Latn-US |
| [简体中文](./Readme-zh.md)      | zh-Hans-CN |
| [繁體中文](./Readme-zh-Hant.md) | zh-Hant-TW |

> Want to support Mehr Sprachen/Más idiomas/Autres langues/Другие языки/...?
>
> Please feel free to send me an issue!

---

<details>
<summary>
Table of Contents (click to expand)
</summary>

- [Learn Sinlog API By Example](#learn-sinlog-api-by-example)
  - [include module](#include-module)
    - [LambdaExt](#lambdaext)
    - [LogLambdaExt](#loglambdaext)
  - [Classic Method Call](#classic-method-call)
- [Advanced](#advanced)
  - [Real World Example](#real-world-example)
  - [Log Levels](#log-levels)
  - [Environment Variables](#environment-variables)
  - [Log Output Device/Path](#log-output-devicepath)
  - [Other Logger Methods](#other-logger-methods)
  - [Notes](#notes)
- [Side Note](#side-note)
- [License](#license)

</details>

## Learn Sinlog API By Example

First, install `sinlog`.

```sh
gem install sinlog
```

Then, we can run `irb` to quickly try it out.

### include module

#### LambdaExt

When you see: `irb(main):001>`, we can start operating.

```ruby
irb(main):001> require 'sinlog'

irb(main):002> include Sinlog::LambdaExt
# It provides: dbg, info, warning, err, fatal, unk
# We can call them using .tap(&dbg) or .then(&dbg).

irb(main):003> 'debug'.tap(&dbg)
irb(main):004> 'information'.tap(&info)

# Note: Creating a warn method will cause issues with irb's auto-completion.
# Therefore, LambdaExt uses warning instead of warn.
# If you really need warn, then call include Sinlog::LambdaWarnExt
irb(main):005> 'warning'.tap(&warning)

irb(main):006> 'error'.tap(&err)
irb(main):007> 'fatal'.tap(&fatal)
irb(main):008> 'unknown'.tap(&unk)
```

<img src="../assets/img/LambdaExt.jpg" alt="LambdaExt" style="width: 50%; height: 50%">

LambdaExt provides:

- dbg
- info
- warning
- wng (same as warning, just a different name)
- err
- fatal
- unk

#### LogLambdaExt

There is a module very similar to LambdaExt called LogLambdaExt.  
The main difference between them is the naming of the lambda functions.

- LogLambdaExt has a `log_` prefix
- LambdaExt does not

LambdaExt and LogLambdaExt can be included simultaneously, but in general, including one of them is sufficient.

Which one is better?

Let's try them out to understand the differences and choose the one we prefer.

```ruby
irb(main):009> include Sinlog::LogLambdaExt
# It provides log_dbg, log_info, log_warn, log_err, log_fatal, log_unk
# We can call them using .tap(&log_dbg) or .then(&log_dbg).

irb(main):010> "debug".tap(&log_dbg)
irb(main):011> "information".tap(&log_info)

# Note: Here we use log_warn, not log_warning
irb(main):012> "warning".tap(&log_warn)

irb(main):013> "error".tap(&log_err)
irb(main):014> "fatal".tap(&log_fatal)
irb(main):015> "unknown".tap(&log_unk)
```

```ruby
# Here is a more complex example
irb(main):016> require 'pathname'

irb(main):017> Pathname('lib/lambda.rb').tap do
    "Filename: #{it}".then(&log_info)
    "size: #{
      it
        .tap{ '⚠️ Getting file size might fail'.then(&log_warn) }
        .size
    }".then(&log_info)
end
```

<img src="../assets/img/LogLambdaExt.jpg" alt="LogLambdaExt" style="width: 90%; height: 90%">

LogLambdaExt provides:

- log_dbg
- log_info
- log_warn
- log_warning (same as log_warn, just a different name)
- log_wng (same as log_warn, just a different name)
- log_err
- log_fatal
- log_unk

### Classic Method Call

If you don't like lambdas, you can try the classic method call!

First, run `irb` to enter the Ruby REPL, then follow these steps:

```ruby
irb(main):001> require 'sinlog'

irb(main):002> log = Sinlog.instance.logger

irb(main):003> log.debug 'debug'
irb(main):004> log.info 'information'
irb(main):005> log.warn 'warning'
irb(main):006> log.error 'error'
irb(main):007> log.fatal 'fatal'
irb(main):008> log.unknown 'unknown'
```

Sinlog.instance.logger provides methods from Ruby's standard library logger.

The most common ones are:

- debug
- info
- warn
- error
- fatal
- unknown

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
    @logger = logger || Sinlog.instance.tap { it.fetch_env_and_update_log_level("XX_LOG") }.logger
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

```ruby
p Sinlog::LV
# => {debug: 0, info: 1, warn: 2, error: 3, fatal: 4, unknown: 5}

# Change the log level to warn
log = Sinlog.instance.logger.tap { it.level = Sinlog::LV[:warn] }
# Or:
# log = Sinlog.instance.logger.tap { it.level = 2 }

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

By default, Sinlog will attempt to read the value of the environment variable `RUBY_LOG`.

It essentially calls the function `fetch_env_and_update_log_level(env_name = 'RUBY_LOG')`.

- If the environment variable does not exist, it uses `debug(0)`.
- If the environment variable exists but is empty, it uses `unknown(5)`.
- If the environment variable's value is invalid, it uses `unknown(5)`.

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
logger = Sinlog.instance.tap { it.fetch_env_and_update_log_level("XX_CLI_LOG") }.logger

logger.debug "This message will not be displayed because the current log level is INFO(1)."
logger.info "Hello!"
```

### Log Output Device/Path

By default, Sinlog outputs to `STDERR`.

If you need to customize the log output path, you can call the logger's `reopen` method.

```ruby
# Logs will be output to the file a.log
log = Sinlog.instance.logger.tap { it.reopen("a.log") }

log.error "What happened! QuQ"
```

OR:

```ruby
log = Sinlog.instance.logger
log.reopen("a.log")

log.error "What happened! QuQ"
```

### Other Logger Methods

In addition to `.reopen` and `.level`, we can also call other methods from Ruby's standard library logger on `Sinlog.instance.logger`.

### Notes

Sinlog uses the Singleton pattern, meaning the entire program will share the same instance (logger).

Modifying Sinlog in class A of the same program will affect Sinlog in class B.

## Side Note

This is the first Ruby gem I have released.  
The API might not fully adhere to idiomatic Ruby usage, so I appreciate your understanding.

## License

[MIT License](../License)
