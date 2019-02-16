(defvar spacemail-attachment-default-directory nil
  "The default directory to save email attachments to.
   Can be the path to the directory or `nil'.")

(eval-after-load "org"
  '(require 'org-notmuch))

(setq-default notmuch-search-oldest-first nil)
(setq-default notmuch-archive-tags '("-inbox" "-unread"))
(setq notmuch-show-mark-read-tags '("-unread" "+read"))
(setq mm-text-html-renderer 'w3m)

(defface notmuch-tag-spam
  '((((class color)
      (background dark))
     (:foreground "red"))
    (((class color)
      (background light))
     (:foreground "red")))
  "Face used for the spam tag."
  :group 'notmuch-faces)

(defface notmuch-tag-external
  '((((class color)
      (background dark))
     (:foreground "salmon"))
    (((class color)
      (background light))
     (:foreground "salmon")))
  "Face used for the external tag."
  :group 'notmuch-faces)

(defface notmuch-tag-me
  '((((class color)
      (background dark))
     (:foreground "yellow green"))
    (((class color)
      (background light))
     (:foreground "yellow green")))
  "Face used for the me tag."
  :group 'notmuch-faces)

(defface notmuch-tag-interesting
  '((((class color)
      (background dark))
     (:foreground "NavajoWhite"))
    (((class color)
      (background light))
     (:foreground "NavajoWhite")))
  "Face used for the interesting tag."
  :group 'notmuch-faces)

(eval-after-load "notmuch"
  '(progn
     (add-to-list 'notmuch-tag-formats '("me" (propertize tag 'face 'notmuch-tag-me)))
     (add-to-list 'notmuch-tag-formats '("interesting" (propertize tag 'face 'notmuch-tag-interesting)))
     (add-to-list 'notmuch-tag-formats '("spam" (propertize tag 'face 'notmuch-tag-spam)))
     (add-to-list 'notmuch-tag-formats '("external" (propertize tag 'face 'notmuch-tag-external)))))
