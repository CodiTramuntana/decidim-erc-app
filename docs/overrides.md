# Overrides

This document lists all the overrides that have been done at the Decidim platform. Those overrides can conflict with platform updates. During a platform upgrade they need to be compared to the ones of the Decidim project.

The best way to spot these problems is reviewing the changes in the files that are overriden using git history and apply the changes manually.

## Modified

- Add amendment exportation features to proposal components. [\#22](https://github.com/CodiTramuntana/decidim-i2cat-app/pull/22)
  - `app/views/decidim/proposals/admin/proposals/_bulk-actions.html.erb`