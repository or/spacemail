(setq spacemail-packages
    '(notmuch
      notmuch-labeler
      counsel-notmuch
      w3m))

;; List of packages to exclude.
(setq spacemail-excluded-packages '())

;; For each package, define a function spacemail/init-<package-notmuch>
(defun spacemail/init-notmuch ()
  "Initialize the package"
  (use-package notmuch
    :defer t
    ;; :commands notmuch
    :init (progn
            (require 'notmuch)
            (spacemacs/set-leader-keys
              "amm" 'counsel-notmuch
              "amn" 'spacemail/new-mail
              "amj" 'spacemail/jump-search
              "amu" 'spacemail/unread
              "ami" 'spacemail/inbox-and-unread)

            (spacemacs/set-leader-keys-for-major-mode 'notmuch-show
              "tt" 'notmuch-show-add-tag
              "t+" 'notmuch-show-add-tag
              "t-" 'notmuch-show-remove-tag
              )

            (spacemacs/set-leader-keys-for-major-mode 'notmuch-search-mode
              "tt" 'notmuch-search-add-tag
              "t+" 'notmuch-search-add-tag
              "t-" 'notmuch-search-remove-tag
              "t*" 'notmuch-search-tag-all
              "r" 'notmuch-search-refresh-view
              )

            (spacemacs/set-leader-keys-for-major-mode 'notmuch-tree-mode
              "tt" 'notmuch-tree-tag-thread
              "t+" 'notmuch-tree-add-tag
              "t-" 'notmuch-tree-remove-tag
              "r" 'notmuch-tree-refresh-view
              ;; "d" 'notmuch-tree-archive-message-then-next
              ;; "A" 'notmuch-tree-archive-thread
              "g" 'notmuch-poll-and-refresh-this-buffer
              "s" 'notmuch-tree-to-tree
              "c" 'notmuch-show-stash-map
              "m" 'notmuch-mua-new-mail
              "w" 'notmuch-show-save-attachments
              "$" 'notmuch-tree-mark-message-spam)

            (spacemacs/set-leader-keys-for-major-mode 'notmuch-message-mode
              "," 'notmuch-mua-send-and-exit
              "k" 'message-kill-buffer
              "s" 'notmuch-draft-save)
            )

    :config (progn
              ;; ;; Fix helm
              ;; ;; See id:m2vbonxkum.fsf@guru.guru-group.fi
              ;; (setq notmuch-address-selection-function
              ;;       (lambda (prompt collection initial-input)
              ;;         (completing-read prompt (cons initial-input collection) nil t nil 'notmuch-address-history)))

              (evilified-state-evilify-map notmuch-hello-mode-map
                :mode notmuch-hello-mode
                :bindings
                (kbd "q") 'notmuch-bury-or-kill-this-buffer
                )

              (evilified-state-evilify-map notmuch-search-mode-map
                :mode notmuch-search-mode
                :bindings
                (kbd "q") 'notmuch-bury-or-kill-this-buffer
                (kbd "f") 'notmuch-search-filter
                (kbd "s") 'notmuch-tree-to-tree
                )

              (evilified-state-evilify-map notmuch-tree-mode-map
                :mode notmuch-tree-mode
                :bindings
                (kbd "q") 'notmuch-bury-or-kill-this-buffer
                (kbd "r") 'notmuch-tree-mark-message-read-then-next
                (kbd "u") 'notmuch-tree-mark-message-unread-then-next
                (kbd "U") 'notmuch-tree-unarchive-thread
                (kbd "?") 'notmuch-help
                (kbd "RET") 'spacemail/tree-show-message
                (kbd "}") 'notmuch-tree-scroll-or-next
                (kbd "{") 'notmuch-tree-scroll-message-window-back
                (kbd "s") 'notmuch-tree-to-tree
                (kbd "$") 'notmuch-tree-mark-message-spam
                )

              (evilified-state-evilify-map notmuch-show-stash-map
                :mode notmuch-show-mode)
              (evilified-state-evilify-map notmuch-show-part-map
                :mode notmuch-show-mode)
              (evilified-state-evilify-map notmuch-show-mode-map
                :mode notmuch-show-mode
                :bindings
                (kbd "N") 'notmuch-show-next-message
                (kbd "n") 'notmuch-show-next-open-message
                (kbd "R") 'notmuch-show-reply
                (kbd "r") 'notmuch-show-reply-sender)

              ;; (evilify notmuch-hello-mode notmuch-hello-mode-map
              ;;          (kbd "C-j") 'widget-forward
              ;;          (kbd "C-k") 'widget-backward
              ;;          )
              ;; (evilify notmuch-show-mode notmuch-show-stash-map)
              ;; (evilify notmuch-show-mode notmuch-show-part-map)

              ;; (evilify notmuch-show-mode notmuch-show-mode-map
              ;;          (kbd "N") 'notmuch-show-next-message
              ;;          (kbd "n") 'notmuch-show-next-open-message)
              ;; (evilify notmuch-tree-mode notmuch-tree-mode-map)
              ;; (evilify notmuch-search-mode notmuch-search-mode-map)

              (evil-define-key 'visual notmuch-search-mode-map
                "*" 'notmuch-search-tag-all
                "-" 'notmuch-search-remove-tag
                "+" 'notmuch-search-add-tag
                )

              ;; (spacemacs/set-leader-keys-for-major-mode 'notmuch-show-mode
              ;;   "nc" 'notmuch-show-stack-cc
              ;;   "n|" 'notmuch-show-pipe-message
              ;;   "nw" 'notmuch-show-save-attachments
              ;;   "nv" 'notmuch-show-view-raw-message)
              )
    ;; :init (tabbar-mode)
    ;; :bind (("C-<tab>" . tabbar-forward-tab)
    ;;        ("C-S-<tab>" . tabbar-backward-tab)))
    )

  ;; fixes: killing a notmuch buffer does not show the previous buffer
  (push "\\*notmuch-show\\*" spacemacs-useful-buffers-regexp)
  )

(defun spacemail/init-notmuch-labeler ()
  "Initialize the package"
  (use-package notmuch-labeler
    :defer t
    :init (with-eval-after-load 'notmuch)
    )
  )

(defun spacemail/init-w3m ()
  "Initialize the package"
  (use-package w3m
    :defer t
    :init (progn
            (require 'w3m)
            (setq w3m-fill-column 72)
            )
    )
  )

(defun spacemail/init-counsel-notmuch ()
  "Initialize the package"
  (use-package counsel-notmuch
    :defer t
    :init (with-eval-after-load 'notmuch)
    )
  )
