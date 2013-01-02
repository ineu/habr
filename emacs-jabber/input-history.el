
(defvar my-jabber-input-history '() "Variable that holds input history")
(make-variable-buffer-local 'my-jabber-input-history)

(defvar my-jabber-input-history-position 0 "Current position in input history")
(make-variable-buffer-local 'my-jabber-input-history-position)

(defvar my-jabber-input-history-current nil "Current input value")
(make-variable-buffer-local 'my-jabber-input-history-current)

(defun my-jabber-input-history-hook (body id)
  (add-to-list 'my-jabber-input-history body t)
  (setq my-jabber-input-history-position (length my-jabber-input-history)))
(add-hook 'jabber-chat-send-hooks 'my-jabber-input-history-hook)

(defun my-jabber-previous-input ()
  (interactive)
  (let (current-input (pos my-jabber-input-history-position) (len (length my-jabber-input-history)))
    (if (= pos 0)
        (message "%s" "No previous input")
      (setq current-input (delete-and-extract-region jabber-point-insert (point-max)))
      (when (= pos len) ; running first time, save current input
          (setq my-jabber-input-history-current current-input))
      (decf my-jabber-input-history-position)
      (insert (nth my-jabber-input-history-position my-jabber-input-history)))))

(defun my-jabber-next-input ()
  (interactive)
  (let ((pos my-jabber-input-history-position) (len (length my-jabber-input-history)))
    (cond
     ((= pos (1- len)) ; pointing at the last element, insert saved input
       (incf my-jabber-input-history-position)
       (delete-region jabber-point-insert (point-max))
       (insert my-jabber-input-history-current)
       (setq my-jabber-input-history-current nil))
      ((= pos len)                              ; pointing beyound last element, notify user
       (message "%s" "No next input"))
      (t                                ; insert next history item
       (incf my-jabber-input-history-position)
       (delete-region jabber-point-insert (point-max))
       (insert (nth my-jabber-input-history-position my-jabber-input-history))))))

(define-key jabber-chat-mode-map (kbd "M-p") 'my-jabber-previous-input)
(define-key jabber-chat-mode-map (kbd "M-n") 'my-jabber-next-input)

(defun my-jabber-input-history-choose ()
  (interactive)
  (let ((choice (ido-completing-read "Select history item: " (reverse my-jabber-input-history))))
    (delete-region jabber-point-insert (point-max))
    (insert choice)))
