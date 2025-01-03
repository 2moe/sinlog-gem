# Sinlog

一个非常非常简单的 ruby 单例日志记录器，其中日志级别带有彩色高亮。

> 单例（Singleton）意味着整个程序会共享同一个实例（日志记录器）。

[![Gem Version](https://badge.fury.io/rb/sinlog.svg?icon=si%3Arubygems)](https://rubygems.org/gems/sinlog)   [![RubyDoc](https://img.shields.io/badge/-y?label=rubydoc&color=orange)](https://www.rubydoc.info/gems/sinlog)

---

| Language/語言                   | ID         |
| ------------------------------- | ---------- |
| 简体中文                        | zh-Hans-CN |
| [English](./Readme.md)          | en-Latn-US |
| [繁體中文](./Readme-zh-Hant.md) | zh-Hant-TW |

---

<details>
<summary>
目录（点击展开）
</summary>

- [Learn Sinlog API By Example](#learn-sinlog-api-by-example)
  - [include module](#include-module)
    - [LambdaExt](#lambdaext)
    - [LogLambdaExt](#loglambdaext)
  - [Classic Method Call](#classic-method-call)
- [进阶](#进阶)
  - [Real World Example](#real-world-example)
  - [日志级别](#日志级别)
  - [环境变量](#环境变量)
  - [日志输出设备/路径](#日志输出设备路径)
  - [其他 logger 方法](#其他-logger-方法)
  - [注意事项](#注意事项)
- [题外话](#题外话)
- [License](#license)

</details>

## Learn Sinlog API By Example

首先，安装 sinlog。

```sh
gem install sinlog
```

然后，我们可以运行 `irb` 来快速体验一番。

### include module

#### LambdaExt

当出现： `irb(main):001>` 后，我们就能开始操作了。

```ruby
irb(main):001> require 'sinlog'

irb(main):002> include Sinlog::LambdaExt
# 它提供了: dbg, info, warning, err, fatal, unk
# 我们可以用 .tap(&dbg) 或 .then(&dbg) 来调用。

irb(main):003> 'debug'.tap(&dbg)
irb(main):004> 'information'.tap(&info)

# 注：创建 warn 方法，会导致 irb 的补全功能出问题。
#   因此 LambdaExt 用的是 warning, 而不是 warn。
#   您如果确实需要 warn，那就调用 include Sinlog::LambdaWarnExt
irb(main):005> 'warning'.tap(&warning)

irb(main):006> 'error'.tap(&err)
irb(main):007> 'fatal'.tap(&fatal)
irb(main):008> 'unknown'.tap(&unk)
```

<img src="../assets/img/LambdaExt.jpg" alt="LambdaExt" style="width: 50%; height: 50%">

LambdaExt 提供了:

- dbg
- info
- warning
- wng (与 warning 相同，只是名称不同)
- err
- fatal
- unk

#### LogLambdaExt

有一个与 LambdaExt 特别相似的模块，名为 LogLambdaExt。  
它们之间最主要的区别在于方法的名称。

- LogLambdaExt 带有 `log_` 前缀
- LambdaExt 没有

LambdaExt 与 LogLambdaExt 可以同时 include, 不过在一般情况下，我们引入其中一个就够用了。

至于哪一个更好呢？

我们不妨亲自上手试试，了解其中的区别，最后挑一个自己喜欢的。

```ruby
irb(main):009> include Sinlog::LogLambdaExt
# 它提供了 log_dbg, log_info, log_warn, log_err, log_fatal, log_unk
# 我们可以用 .tap(&log_dbg) 或 .then(&log_dbg) 来调用。

irb(main):010> "debug".tap(&log_dbg)
irb(main):011> "information".tap(&log_info)

# 注：这里用的是 log_warn，而不是 log_warning
irb(main):012> "warning".tap(&log_warn)

irb(main):013> "error".tap(&log_err)
irb(main):014> "fatal".tap(&log_fatal)
irb(main):015> "unknown".tap(&log_unk)
```

```ruby
# 这是一个更复杂的例子
irb(main):016> require 'pathname'

irb(main):017> Pathname('lib/lambda.rb').tap do
    "Filename: #{it}".then(&log_info)
    "size: #{
      it
        .tap{ '⚠️ 获取文件大小可能会失败'.then(&log_warn) }
        .size
    }".then(&log_info)
end
```

<img src="../assets/img/LogLambdaExt.jpg" alt="LogLambdaExt" style="width: 90%; height: 90%">

LogLambdaExt 提供了:

- log_dbg
- log_info
- log_warn
- log_warning (与 log_warn 相同，只是名称不同)
- log_wng (与 log_warn 相同，只是名称不同)
- log_err
- log_fatal
- log_unk

### Classic Method Call

您如果不喜欢 lambda，那就试试经典的方法调用吧！

先运行 irb 进入 ruby repl，接着一步一步运行。

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

Sinlog.instance.logger 提供了 ruby 标准库的 logger 的方法。

最常见的有：

- debug
- info
- warn
- error
- fatal
- unknown

## 进阶

在亲自上手尝试之后，我们已经对 sinlog 有了初步的了解。  
在一般情况下，了解其基本用法就已经足够了。

您如果对此感兴趣的话，不妨与我一同继续探索。

### Real World Example

在现实世界中，我们的程序可能会是这样子的：

```ruby
require 'sinlog'

class EpubProcessor
  def initialize(epub_file, logger = nil)
    @epub = epub_file
    @logger = logger || Sinlog.instance.tap { it.fetch_env_and_update_log_level("XX_LOG") }.logger
    @logger.debug "EpubProcessor class 初始化完成。"

  end
end
```

我们可能会定义类的 @logger 实例变量，并允许自定义 logger。

简单来说，我们可能会对 logger 进行更精细化的配置。

在接下来的内容中，我们将探讨如何进行“更精细化的配置”。

### 日志级别

日志级别从低到高，依次是：

- debug = 0
- info = 1
- warn = 2
- error = 3
- fatal = 4
- unknown = 5

```ruby
p Sinlog::LV
# => {debug: 0, info: 1, warn: 2, error: 3, fatal: 4, unknown: 5}

# 将日志级别修改为 warn
log = Sinlog.instance.logger.tap {it.level = Sinlog::LV[:warn]}
# 或者是：
# log = Sinlog.instance.logger.tap {it.level = 2}

log.error "这条消息会显示出来！低级别 WARN（2）会显示高级别 ERROR(3) 的日志。"
log.info "这条消息不会显示出来！高级别 WARN(2) 不会显示低级别 INFO(1) 的日志。"
```

- 日志级别越低，显示的内容越详细。
- 低级别 **会** 显示高级别的日志。
- 高级别 **不会** 显示低级别的日志。

### 环境变量

在现实世界中，对于客户端应用，最后运行程序的是普通用户。  
为了能让普通用户直接配置 log.level，我们可以通过环境变量来配置。

> 使用环境变量足够简单也足够高效。

Sinlog 在默认情况下，会尝试读取环境变量 RUBY_LOG 的值。

本质上调用了 `fetch_env_and_update_log_level(env_name = 'RUBY_LOG')` 函数。

- 若该环境变量不存在，则使用 debug(0)。
- 若该环境变量存在，且其值为空，则使用 unknown(5)。
- 若该环境变量的值无效，则使用 unknown(5)。

我们可以用 POSIX-sh 设置环境变量，然后 logger 在初始化的时候，就会自动将日志级别设置为（RUBY_LOG的值）warn。

```sh
# 可选值：debug, info, warn, error, fatal
export RUBY_LOG=warn
```

您如果不想要默认的 RUBY_LOG 环境变量，而是想要 XX_CLI_LOG 的值，那可以这样子做：

POSIX-sh:

```sh
export XX_CLI_LOG=info
```

ruby:

```ruby
logger = Sinlog.instance.tap { it.fetch_env_and_update_log_level("XX_CLI_LOG") }.logger

logger.debug "由于当前日志级别为 INFO(1)，因此不会显示此消息 DEBUG(0)。"
logger.info "Hello!"
```

### 日志输出设备/路径

默认情况下，Sinlog 会输出到 STDERR。

您如果需要自定义日志输出路径的话，那可以调用 logger 的 reopen 方法。

```ruby
# 日志会输出到 a.log 文件
log = Sinlog.instance.logger.tap {it.reopen("a.log")}

log.error "发生甚么事了！QuQ"
```

OR:

```ruby
log = Sinlog.instance.logger
log.reopen("a.log")

log.error "发生甚么事了！QuQ"
```

### 其他 logger 方法

除了 `.reopen`, `.level` 外，我们还可以在 `Sinlog.instance.logger` 上调用 ruby 标准库的 logger 的其他方法。

### 注意事项

Sinlog 用的是 Singleton 单例模式，整个程序会共享同一个实例（日志记录器）。

在同一个程序的 class A 中修改 Sinlog 后，会影响到 class B 的 Sinlog。

## 题外话

这是我发布的第一个 ruby gem。  
其中的 api 不一定符合地道的 ruby 用法，还请大家多多谅解。

## License

[MIT License](../License)
