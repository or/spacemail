;;; spacemail.el --- description -*- lexical-binding: t; -*-
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Spacemail package for doom-emcs.
;;
;;; Code:


(require 'notmuch)

(use-package notmuch-labeler
  :defer t
  :init (with-eval-after-load 'notmuch)
  )

(use-package w3m
  :defer t
  :init (progn
          (setq w3m-fill-column 72)
          (setq w3m-use-tab nil)
          (setq w3m-use-tab-line nil)))

(defun bind-map-change-major-mode-after-body-hook ())

(load! "funcs")
(load! "config")
(map! :leader
      (:prefix-map ("a" . "app")
        (:prefix-map ("m" . "mail")
          :desc "New mail"           "n"     'spacemail/new-mail
          :desc "Inbox"              "i"     'spacemail/inbox-and-unread
          :desc "Unread"             "u"     'spacemail/unread
          :desc "Jump search"        "j"     'spacemail/jump-search
          )))

(map! :localleader
      :after notmuch
      :map notmuch-show-mode-map
      "tt" 'notmuch-show-add-tag
      "t+" 'notmuch-show-add-tag
      "t-" 'notmuch-show-remove-tag
      )

(map! :localleader
      :after notmuch
      :map notmuch-search-mode-map
      "tt" 'notmuch-search-add-tag
      "t+" 'notmuch-search-add-tag
      "t-" 'notmuch-search-remove-tag
      "t*" 'notmuch-search-tag-all
      "r" 'notmuch-search-refresh-view
      )

(map! :localleader
      :after notmuch
      :map notmuch-tree-mode-map
      "tt" 'notmuch-tree-tag-thread
      "t+" 'notmuch-tree-add-tag
      "t-" 'notmuch-tree-remove-tag
      "r" 'notmuch-tree-refresh-view
      "A" 'notmuch-tree-archive-thread-and-next-message
      "g" 'notmuch-poll-and-refresh-this-buffer
      "s" 'notmuch-tree-to-tree
      "c" 'notmuch-show-stash-map
      "m" 'notmuch-mua-new-mail
      "w" 'notmuch-show-save-attachments
      "$" 'notmuch-tree-mark-message-spam)

(map! :localleader
      :after notmuch
      :map notmuch-message-mode-map
      "," 'notmuch-mua-send-and-exit
      "k" 'message-kill-buffer
      "s" 'notmuch-draft-save)

(map! :after notmuch
      :map notmuch-hello-mode-map
      :mode notmuch-hello-mode
      :n "q" 'notmuch-bury-or-kill-this-buffer)

(map! :after notmuch
      :map notmuch-search-mode-map
      :mode notmuch-search-mode
      :n "q" 'notmuch-bury-or-kill-this-buffer
      :n "f" 'notmuch-search-filter
      :n "s" 'notmuch-tree-to-tree
      )

(map! :after notmuch
      :map  notmuch-tree-mode-map
      :mode notmuch-tree-mode
      :n "q" 'notmuch-bury-or-kill-this-buffer
      :n "r" 'notmuch-tree-mark-message-read-then-next
      :n "i" 'notmuch-tree-mark-message-inbox-then-next
      :n "u" 'notmuch-tree-mark-message-unread-then-next
      :n "U" 'notmuch-tree-unarchive-thread
      :n "?" 'notmuch-help
      :n [return] 'spacemail/tree-show-message
      :n "}" 'notmuch-tree-scroll-or-next
      :n "{" 'notmuch-tree-scroll-message-window-back
      :n "s" 'notmuch-tree-to-tree
      :n "$" 'notmuch-tree-mark-message-spam-then-next
      :n "A" 'notmuch-tree-archive-thread-and-next-message
      :n "=" nil
      )

(map! :after notmuch
      :map  notmuch-show-stash-map
      :mode notmuch-show-mode)

(map! :after notmuch
      :map  notmuch-show-part-map
      :mode notmuch-show-mode)

(map! :after notmuch
      :map  notmuch-show-mode-map
      :mode notmuch-show-mode
      :n "N" 'notmuch-show-next-message
      :n "n" 'notmuch-show-next-open-message
      :n "R" 'notmuch-show-reply
      :n "r" 'notmuch-show-reply-sender
      )

(evil-define-key 'visual notmuch-search-mode-map
  "*" 'notmuch-search-tag-all
  "-" 'notmuch-search-remove-tag
  "+" 'notmuch-search-add-tag
  )

(when spacemail-attachment-default-directory
  (setq mm-default-directory spacemail-attachment-default-directory))

(provide 'spacemail)
;;; spacemail.el ends here
