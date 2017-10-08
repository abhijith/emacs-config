(require 'packages)
(require 'company)

(install-packages '(rust-mode racer flycheck-rust))

(require 'rust-mode)
;; Reference http://julienblanchard.com/2016/fancy-rust-development-with-emacs/

(setq rust-format-on-save t)
(setq racer-rust-src-path "~/repo/srcs-and-packages/rust/src")
(setq company-tooltip-align-annotations t)

(add-hook 'racer-mode-hook #'cargo-minor-mode)

(add-hook 'rust-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c <tab>") 'rust-format-buffer)))

(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'flycheck-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)

(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

(define-key rust-mode-map (kbd "TAB") 'company-indent-or-complete-common)

(provide 'init-rust)
