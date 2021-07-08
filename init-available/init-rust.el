(el-get-bundle rust-mode)
(el-get-bundle emacs-racer)
(el-get-bundle cargo)
(el-get-bundle flycheck-rust)

(use-package rust-mode)
(use-package flycheck-rust)
(use-package rust-mode)

(setq rust-format-on-save t)
(setq racer-rust-src-path "~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library")
(setq company-tooltip-align-annotations t)

(add-hook 'rust-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c <tab>") 'rust-format-buffer)))

(add-hook 'rust-mode-hook #'racer-mode)

(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)

(add-hook 'racer-mode-hook #'flycheck-mode)

(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

(define-key rust-mode-map (kbd "TAB") 'company-indent-or-complete-common)

(setq package-archives '(("melpa" . "http://melpa.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))

(provide 'init-rust)
