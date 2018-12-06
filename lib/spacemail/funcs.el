(defun spacemail/hello ()
  (interactive)
  (notmuch-hello))

(defun spacemail/search ()
  (interactive)
  (notmuch-search :sort-order newes-first))

(defun spacemail/tree ()
  (interactive)
  (notmuch-tree))

(defun spacemail/jump-search ()
  (interactive)
  (notmuch-jump-search)
  (bind-map-change-major-mode-after-body-hook))

(defun spacemail/new-mail ()
  (interactive)
  (notmuch-mua-new-mail))

(defun spacemail/inbox-and-unread ()
  (interactive)
  (notmuch-tree "tag:inbox or tag:unread")
  (bind-map-change-major-mode-after-body-hook))

(defun spacemail/unread ()
  (interactive)
  (notmuch-tree "tag:unread")
  (bind-map-change-major-mode-after-body-hook))

(defun spacemail/tree-show-message ()
  (interactive)
  (notmuch-tree-show-message-in)
  (select-window notmuch-tree-message-window))

(defun spacemail/search-show-message ()
  (interactive)
  (notmuch-search-show-thread)
  (select-window notmuch-tree-message-window))

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

(defun notmuch-tree-mark-message-spam (&optional unread)
  (interactive "P")
  (notmuch-tree-tag (notmuch-tag-change-list '("+spam" "-inbox" "-unread") unread))
  (notmuch-tree-next-matching-message))

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
