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

(defun hermod/inbox-and-unread ()
  (interactive)
  (require 'notmuch)
  (notmuch-tree "tag:inbox or tag:unread")
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
              "ami" 'hermod/inbox-and-unread)

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
              "k" 'message-kill-buffer
              "s" 'notmuch-draft-save)
            )

    :config (progn
              ;; ;; Fix helm
              ;; ;; See id:m2vbonxkum.fsf@guru.guru-group.fi
              ;; (setq notmuch-address-selection-function
              ;;       (lambda (prompt collection initial-input)
              ;;         (completing-read prompt (cons initial-input collection) nil t nil 'notmuch-address-history)))

              (evilified-state-evilify-map 'notmuch-hello-mode-map
                :mode notmuch-hello-mode
                :bindings
                (kbd "q") 'notmuch-bury-or-kill-this-buffer
                )

              (evilified-state-evilify-map 'notmuch-search-mode-map
                :mode notmuch-search-mode
                :bindings
                (kbd "q") 'notmuch-bury-or-kill-this-buffer
                (kbd "r") 'notmuch-search-reply-to-thread
                (kbd "R") 'notmuch-search-reply-to-thread-sender
                (kbd "f") 'notmuch-search-filter
                )

              (evilified-state-evilify-map 'notmuch-show-stash-map :mode notmuch-show-mode)
              (evilified-state-evilify-map 'notmuch-show-part-map :mode notmuch-show-mode)
              (evilified-state-evilify-map 'notmuch-show-mode-map :mode notmuch-show-mode
                :bindings
                (kbd "N") 'notmuch-show-next-message
                (kbd "n") 'notmuch-show-next-open-message)

              (evilified-state-evilify-map 'notmuch-tree-mode-map
                :mode notmuch-tree-mode
                :bindings
                (kbd "q") 'notmuch-bury-or-kill-this-buffer
                (kbd "r") 'notmuch-tree-mark-message-read-then-next
                (kbd "u") 'notmuch-tree-mark-message-unread-then-next
                (kbd "U") 'notmuch-tree-unarchive-thread
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
  )

(defun hermod/init-notmuch-labeler ()
  "Initialize the package"
  (use-package notmuch-labeler
    :defer t
    )
  )

(setq-default notmuch-search-oldest-first nil)
(setq-default notmuch-archive-tags '("-inbox" "-unread"))
(eval-after-load "org"
  '(require 'org-notmuch))

(defun notmuch-tree-mark-message-unread-then-next (&optional unread)
  "Mark the current message as unread and move to next matching message."
  (interactive "P")
  (notmuch-tree-mark-message-read t)
  (notmuch-tree-next-matching-message))

(defun notmuch-tree-mark-message-read-then-next (&optional unread)
  "Mark the current message as read and move to next matching message."
  (interactive "P")
  (notmuch-tree-mark-message-read nil)
  (notmuch-tree-next-matching-message))

(defun notmuch-tree-mark-message-read (&optional unread)
  (interactive "P")
  (notmuch-tree-tag (notmuch-tag-change-list '("-unread") unread)))

(defun notmuch-tree-unarchive-thread (&optional unarchive)
  (interactive "P")
  (when notmuch-archive-tags
    (notmuch-tree-tag-thread
     (notmuch-tag-change-list notmuch-archive-tags t))))

(eval-after-load "message"
  '(defun message-insert-signature (&optional force)
    "Insert a signature.  See documentation for variable `message-signature'."
    (interactive (list 0))
    (let* ((signature
            (cond
             ((and (null message-signature)
                   (eq force 0))
              (save-excursion
                (goto-char (point-max))
                (not (re-search-backward message-signature-separator nil t))))
             ((and (null message-signature)
                   force)
              t)
             ((functionp message-signature)
              (funcall message-signature))
             ((listp message-signature)
              (eval message-signature))
             (t message-signature)))
           signature-file)
      (setq signature
            (cond ((stringp signature)
                   signature)
                  ((and (eq t signature) message-signature-file)
                   (setq signature-file
                         (if (and message-signature-directory
                                  ;; don't actually use the signature directory
                                  ;; if message-signature-file contains a path.
                                  (not (file-name-directory
                                        message-signature-file)))
                             (expand-file-name message-signature-file
                                               message-signature-directory)
                           message-signature-file))
                   (file-exists-p signature-file))))
      (when signature
        (goto-char (point-max))
        ;; Insert the signature.
        (unless (bolp)
          (newline))
        (when message-signature-insert-empty-line
          (newline))
        (if (eq signature t)
            (insert-file-contents signature-file)
          (insert signature))
        (goto-char (point-max))
        (or (bolp) (newline))))))

(eval-after-load "notmuch"
  '(defun notmuch-show-insert-part-text/calendar (msg part content-type nth depth button)
    (notmuch-show-insert-part-*/* msg part content-type nth depth button)))
