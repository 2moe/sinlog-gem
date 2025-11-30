# Sinlog

一個非常非常簡單的 ruby 單例日誌記錄器，其中日誌級別帶有彩色高亮。

> 單例（Singleton）意味著整個程式會共享同一個例項（日誌記錄器）。

[![Gem Version](https://badge.fury.io/rb/sinlog.svg?icon=si%3Arubygems)](https://rubygems.org/gems/sinlog)
<!-- [![RubyDoc](https://img.shields.io/badge/-y?label=rubydoc&color=orange)](https://www.rubydoc.info/gems/sinlog) -->

---

| Language/語言              | ID         |
| -------------------------- | ---------- |
| 繁體中文                   | zh-Hant-TW |
| [English](./Readme.md)     | en-Latn-US |
| [简体中文](./Readme-zh.md) | zh-Hans-CN |

---

<details>
<summary>
目錄（點選展開）
</summary>

- [快速上手](#快速上手)
- [安裝](#安裝)
  - [Monkey Patching 模組對照表](#monkey-patching-模組對照表)
  - [方法列表](#方法列表)
    - [Mixin \& Refin](#mixin--refin)
    - [ShortMixin \& ShortRefin](#shortmixin--shortrefin)
  - [例子](#例子)
    - [經典方法呼叫 (非 mixin，亦非 refinement)](#經典方法呼叫-非-mixin亦非-refinement)
    - [Refinement](#refinement)
    - [Mixin](#mixin)
- [Learn Sinlog API By Example](#learn-sinlog-api-by-example)
  - [Classic Method Call](#classic-method-call)
- [進階](#進階)
  - [Real World Example](#real-world-example)
  - [日誌級別](#日誌級別)
  - [環境變數](#環境變數)
  - [日誌輸出裝置/路徑](#日誌輸出裝置路徑)
  - [其他 logger 方法](#其他-logger-方法)
  - [注意事項](#注意事項)
- [題外話](#題外話)
- [License](#license)

</details>

## 快速上手

## 安裝

```sh
# POSIX-sh
#
gem install sinlog
```

### Monkey Patching 模組對照表

| 模組       | Type       | Activation | 方法                                                     |
| ---------- | ---------- | ---------- | -------------------------------------------------------- |
| Mixin      | Mixin      | include    | log_dbg, log_info, log_warn, log_err, log_fatal, log_unk |
| Refin      | Refinement | using      | log_dbg, log_info, log_warn, log_err, log_fatal, log_unk |
| ShortMixin | Mixin      | include    | dbg, info, warn, err, fatal, unk                         |
| ShortRefin | Refinement | using      | dbg, info, warn, err, fatal, unk                         |

### 方法列表

#### Mixin & Refin

- `log_dbg`   – DEBUG
- `log_info`  – INFO
- `log_warn`  – WARN
- `log_err`   – ERROR
- `log_fatal` – FATAL
- `log_unk`   – UNKNOWN

#### ShortMixin & ShortRefin

- ShortRefin 類似於 Refin
  - 除了方法的命名不同外，二者的內部實現沒有任何區別。
    - Refin 的方法帶有 `log_` 字首
    - ShortRefin 沒有

- ShortMixin 類似於 Mixin
  - 二者的區別只是命名不同
    - Mixin 的方法帶有 `log_` 字首
    - ShortMixin 沒有

---

- `dbg`   – DEBUG
- `info`  – INFO
- `warn`  – WARN
- `err`   – ERROR
- `fatal` – FATAL
- `unk`   – UNKNOWN

> ⚠️ 由於 ShortMixin & ShortRefin 帶有 warn 方法，因此會覆蓋 warn。
> 對於 ruby 程式碼中的 `warn "msg"` (輸出到 stderr 而非輸出為日誌格式)，您可能需要手動將其修改為 `Kernel.warn "msg"`。
>
> 如果介意的話，那就使用 `using Sinlog::Refin` 而不是 `using Sinlog::ShortRefin`。

### 例子

#### 經典方法呼叫 (非 mixin，亦非 refinement)

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

## Learn Sinlog API By Example

<img src="../assets/img/預覽.webp" alt="預覽">

```ruby
require 'sinlog'

module A
  module_function
  using Sinlog::ShortRefin

  def log
    ['喂喂喂123，能看到這條除錯訊息嗎？',
    '您可能會覺得我有點囉嗦，哈哈哈！'].dbg
    '神經，害我笑了一下。'.info

    '開門！查水錶。'.warn
    { error: "IO", type: "輸入資料無效" }.err
    '不行啦！出錯了，繼續執行下去會壞掉的。'.err
    '滋滋滋，已經壞..掉...了..了~'.fatal
  end
end


A.log

# 修改日誌級別為 error
Sinlog.logger(level: 'err')
Kernel.warn 'Logger.level => error'
A.log
```

### Classic Method Call

您如果不喜歡 `msg.info` 這種做法 ，那不妨試試經典的方法呼叫吧！(i.e., `log.info(msg)`)

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

> `Sinlog.logger` 的資料型別為 ruby 標準庫的 Logger。

除了以下這些常見的方法外，您還可以使用 `.reopen` 等其他的方法，詳見 <https://docs.ruby-lang.org.cn/en/3.4/Logger.html>

- debug
- info
- warn
- error
- fatal
- unknown

## 進階

在親自上手嘗試之後，我們已經對 sinlog 有了初步的瞭解。
在一般情況下，瞭解其基本用法就已經足夠了。

您如果對此感興趣的話，不妨與我一同繼續探索。

### Real World Example

在現實世界中，我們的程式可能會是這樣子的：

```ruby
require 'sinlog'

class EpubProcessor
  def initialize(epub_file, logger = nil)
    @epub = epub_file
    logger ||= Sinlog::logger(env_name: "XX_LOG")
    @logger = logger
    @logger.debug "EpubProcessor class 初始化完成。"
  end
end
```

我們可能會定義類的 @logger 例項變數，並允許自定義 logger。

簡單來說，我們可能會對 logger 進行更精細化的配置。

在接下來的內容中，我們將探討如何進行“更精細化的配置”。

### 日誌級別

日誌級別從低到高，依次是：

- debug = 0
- info = 1
- warn = 2
- error = 3
- fatal = 4
- unknown = 5

> 有意思的一點是： ruby 的標準庫的 logger 的日誌級別與 rust 的 [log::Level](https://docs.rs/log/latest/log/enum.Level.html) 是相反的。

```ruby
p Sinlog::LV
# => {debug: 0, info: 1, warn: 2, error: 3, fatal: 4, unknown: 5}

# 將日誌級別修改為 warn
log = Sinlog.logger(level: 'warn')
# OR:
#   log = Sinlog.logger(level: Sinlog::LV[:warn])
# OR:
#   log = Sinlog.logger.tap { it.level = 2 }

log.error "這條訊息會顯示出來！低級別 WARN（2）會顯示高級別 ERROR(3) 的日誌。"
log.info "這條訊息不會顯示出來！高級別 WARN(2) 不會顯示低級別 INFO(1) 的日誌。"
```

- 日誌級別越低，顯示的內容越詳細。
- 低級別 **會** 顯示高級別的日誌。
- 高級別 **不會** 顯示低級別的日誌。

### 環境變數

在現實世界中，對於客戶端應用，最後執行程式的是普通使用者。
為了能讓普通使用者直接配置 log.level，我們可以透過環境變數來配置。

> 使用環境變數足夠簡單也足夠高效。

`Sinlog::Logger` 在初始化時，會嘗試讀取環境變數 `RUBY_LOG` 的值。

- 若該環境變數不存在，則使用 debug(0)。
- 若該環境變數存在，且其值為空，則使用 error(3)。
- 若該環境變數的值無效，則使用 error(3)。

我們可以用 POSIX-sh 設定環境變數，然後 logger 在初始化的時候，就會自動將日誌級別設定為（RUBY_LOG的值）warn。

```sh
# 可選值：debug, info, warn, error, fatal
export RUBY_LOG=warn
```

您如果不想要預設的 RUBY_LOG 環境變數，而是想要 XX_CLI_LOG 的值，那可以這樣子做：

POSIX-sh:

```sh
export XX_CLI_LOG=info
```

ruby:

```ruby
logger = Sinlog.logger(env_name:"XX_CLI_LOG")

logger.debug "由於當前日誌級別為 INFO(1)，因此不會顯示此訊息 DEBUG(0)。"
logger.info "Hello!"
```

### 日誌輸出裝置/路徑

預設情況下，Sinlog 會輸出到 `STDERR`。

您如果需要自定義日誌輸出路徑的話，那可以呼叫 logger 的 reopen 方法。

```ruby
# 日誌會輸出到 a.log 檔案
log = Sinlog.logger.tap {it.reopen("a.log")}

log.error "發生甚麼事了！QuQ"
```

OR:

```ruby
log = Sinlog.logger
log.reopen("a.log")

log.error "發生甚麼事了！QuQ"
```

### 其他 logger 方法

除了 `.reopen`, `.level` 外，我們還可以在 `Sinlog.logger` 上呼叫 ruby 標準庫的 logger 的其他方法。

### 注意事項

`Sinlog::Logger` 用的是 Singleton 單例模式，整個程式會共享同一個例項（日誌記錄器）。

在同一個程式的 class A 中修改 `Sinlog.logger` (a.k.a. `Sinlog::Logger.instance.logger`) 後，會影響到 class B 的 `Sinlog::Logger`。

## 題外話

這是我釋出的第一個 ruby gem。
其中的 api 不一定符合地道的 ruby 用法，還請大家多多諒解。

## License

[MIT License](../License)
