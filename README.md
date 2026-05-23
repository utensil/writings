utensil/writings
================

[![publish](https://github.com/utensil/writings/actions/workflows/ruby.yml/badge.svg)](https://github.com/utensil/writings/actions/workflows/ruby.yml)

Utensil's writings (随笔 / 文章), built with [Middleman](https://middlemanapp.com/).

Published at <https://utensil.github.io/writings/>.

This repository was split out of [utensil/utensil.github.io](https://github.com/utensil/utensil.github.io)
with full git history and original timestamps preserved (via `git filter-repo`).
Its companion is [utensil/tech](https://github.com/utensil/tech).

Build
-----

```
bundle
bundle exec middleman server   # local preview
bundle exec middleman build    # output in build/
```

A push to the `middleman` branch builds the site and deploys it to GitHub Pages
via `.github/workflows/ruby.yml`.

Licence
-------

Code is licensed under the MIT License (see `LICENSE.md`). Blog content is
licensed under [(CC) BY-NC-ND](http://creativecommons.org/licenses/by-nc-nd/3.0/).

Copyright (c) Utensil (https://github.com/utensil)
