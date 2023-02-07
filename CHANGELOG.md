## [Unreleased]

## [1.1.0] - 2023-01-07

- Allow `@slow` if it's only `O(1)` complexity, e.g. the `SET` (string) command.

## [1.0.0] - 2022-12-02

- Initial release
- Support for `redis` v4.6 onwards (latset v5.0.5 supported at time of writing)
- `SaferRedis.activate!` and `SaferRedis.really { … }` interface.
