(use-package highline :straight t)
(use-package dired-details :straight t)
(use-package wdired :straight t)

(defun highline-mode-on () (highline-mode 1))
(add-hook 'dired-after-readin-hook #'highline-mode-on)

(setq dired-details-hidden-string "")

(defun dired-lynx-keybindings ()
  (define-key dired-mode-map [left]  'dired-up-directory)
  (define-key dired-mode-map [right]  'dired-view-file))

(add-hook 'dired-mode-hook 'dired-lynx-keybindings)

(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
(dired-details-install)

(add-hook 'dired-load-hook
	(lambda ()
		(load "dired-x")
		;; Set dired-x global variables here.  For example:
		(setq dired-guess-shell-gnutar "rm")
		(setq dired-x-hands-off-my-keys nil)))

(defun dired-dotfiles-toggle ()
  "Show/hide dot-files"
  (interactive)
  (when (equal major-mode 'dired-mode)
    (if (or (not (boundp 'dired-dotfiles-show-p)) dired-dotfiles-show-p) ; if currently showing
        (progn
          (set (make-local-variable 'dired-dotfiles-show-p) nil)
          (message "h")
          (dired-mark-files-regexp "^\\\.")
          (dired-do-kill-lines))
      (progn (revert-buffer) ; otherwise just revert to re-show
             (set (make-local-variable 'dired-dotfiles-show-p) t)))))

(provide 'init-dired)
