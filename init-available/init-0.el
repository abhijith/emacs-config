(use-package exec-path-from-shell :straight t)
(use-package company :straight t)
(use-package powerline :straight t)
(use-package powerline :straight t)

(setq dotfiles-dir
      (file-name-directory
       (or (buffer-file-name) load-file-name)))

(add-hook 'before-make-frame-hook 'turn-off-tool-bar)

(defalias 'yes-or-no-p 'y-or-n-p)

;; Don't clutter up directories with files~
(setq backup-directory-alist `(("." . ,(expand-file-name
                                        (concat dotfiles-dir "backups")))))

;; make emacs use the clipboard
(setq x-select-enable-clipboard t)

(setq resize-mini-windows nil)

(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)

(setq backup-directory-alist `(("." . "~/.emacs.d/.saves")))
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(define-key global-map (kbd "RET") 'newline-and-indent)

(exec-path-from-shell-initialize)

(powerline-default-theme)

(provide 'init-0)
