(eval-after-load "org"
  '(require 'org-notmuch))
(setq-default notmuch-search-oldest-first nil)
(setq-default notmuch-archive-tags '("-inbox" "-unread"))
(setq notmuch-show-mark-read-tags '("-unread" "+read"))
(setq mm-text-html-renderer 'w3m)
