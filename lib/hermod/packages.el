(setq hermod-packages
    '(notmuch
      notmuch-labeler))

;; List of packages to exclude.
(setq hermod-excluded-packages '())

(defun hermod/hello ()
  (interactive)
  (require 'notmuch)
  (notmuch-hello))

(defun hermod/search ()
  (interactive)
  (require 'notmuch)
  (notmuch-search :sort-order newes-first))

(defun hermod/tree ()
  (interactive)
  (require 'notmuch)
  (notmuch-tree))

(defun hermod/jump-search ()
  (interactive)
  ;; (require 'notmuch)
  (notmuch-jump-search)
  (bind-map-change-major-mode-after-body-hook))

(defun hermod/new-mail ()
  (interactive)
  (require 'notmuch)
  (notmuch-mua-new-mail))

(defun hermod/inbox ()
  (interactive)
  (require 'notmuch)
  (notmuch-tree "tag:inbox")
  (bind-map-change-major-mode-after-body-hook))

(defun hermod/unread ()
  (interactive)
  (require 'notmuch)
  (notmuch-tree "tag:unread")
  (bind-map-change-major-mode-after-body-hook))

(defun hermod/tree-show-message ()
  (interactive)
  (notmuch-tree-show-message-in)
  (select-window notmuch-tree-message-window))

;; For each package, define a function hermod/init-<package-notmuch>
(defun hermod/init-notmuch ()
  "Initialize the package"
  (use-package notmuch
    :defer t
    ;; :commands notmuch
    :init (progn
            (spacemacs/set-leader-keys
              "amm" 'hermod/hello
              "amn" 'hermod/new-mail
              "amj" 'hermod/jump-search
              "amu" 'hermod/unread
              "ami" 'hermod/inbox)

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
              "s" 'notmuch-search-from-tree-current-query
              "c" 'notmuch-show-stash-map
              "m" 'notmuch-mua-new-mail
              "w" 'notmuch-show-save-attachments)

            (spacemacs/set-leader-keys-for-major-mode 'notmuch-message-mode
              "," 'notmuch-mua-send-and-exit
              "k" 'message-kill-buffer)
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
                (kbd "r") 'notmuch-search-reply-to-thread
                (kbd "R") 'notmuch-search-reply-to-thread-sender
                (kbd "f") 'notmuch-search-filter
                )

              (evilified-state-evilify-map notmuch-show-mode-map
                :mode notmuch-show-mode)

              (evilified-state-evilify-map notmuch-tree-mode-map
                :mode notmuch-tree-mode
                :bindings
                (kbd "q") 'notmuch-bury-or-kill-this-buffer
                (kbd "?") 'notmuch-help
                (kbd "RET") 'hermod/tree-show-message
                (kbd "}") 'notmuch-tree-scroll-or-next
                (kbd "{") 'notmuch-tree-scroll-message-window-back)

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
              )
    ;; :init (tabbar-mode)
    ;; :bind (("C-<tab>" . tabbar-forward-tab)
    ;;        ("C-S-<tab>" . tabbar-backward-tab)))
    )
  )

(defun hermod/init-notmuch-labeler ()
  "Initialize the package"
  (use-package notmuch-labeler
    :defer t
    )
  )
