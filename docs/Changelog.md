# ChangeLog

- [2025](#2025)
  - [v0.0.6 (2025-11-30)](#v006-2025-11-30)
  - [v0.0.3](#v003)

## 2025

### v0.0.6 (2025-11-30)

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

### v0.0.3

- `Sinlog.instance.logger` can be simplified => `Sinlog.logger`

- add `Sinlog.logger_with_level`
  - e.g., `logger = Sinlog.logger_with_level(Sinlog::LV[:warn])`
  - old: `Sinlog.instance.logger.tap { it.level = Sinlog::LV[:warn] }`

- add `LogExt`, `LogShortExt` and `Loggable`

- add sorbet **.rbi** files

Breaking changes:
- `fetch_env_and_update_log_level(ENV_NAME)` => `set_level_from_env!(ENV_NAME)`
- remove `LogLambdaExt` and related modules
