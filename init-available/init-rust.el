(use-package rust-mode :straight t)
(use-package racer :straight t)
(use-package cargo :straight t)
(use-package flycheck-rust :straight t)

(setq rust-format-on-save t)
(setq racer-rust-src-path "~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library")
(setq company-tooltip-align-annotations t)
(setq company-idle-delay 0.8)

(add-hook 'rust-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c <tab>") 'rust-format-buffer)))

(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)
(add-hook 'racer-mode-hook #'flycheck-mode)
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

(define-key rust-mode-map (kbd "TAB") 'company-indent-or-complete-common)

(provide 'init-rust)
