;; (require 'packages)

;; go-autocomplete dependency
;; go get -u github.com/mdempsky/gocode

;; go get github.com/rogpeppe/godef

;; go imports
;; go get golang.org/x/tools/cmd/goimports

(straight-use-package 'go-mode)
;; (straight-use-package 'go-autocomplete)
;; (straight-use-package 'go-errcheck)
;; (straight-use-package 'go-eldoc)
(straight-use-package 'protobuf-mode)

;; (defun my-go-mode-hook ()
;;   ; Use goimports instead of go-fmt
;;   (setq gofmt-command "goimports")
;;   ; Call Gofmt before saving
;;   (add-hook 'before-save-hook 'gofmt-before-save)
;;   ; Customize compile command to run go build
;;   (if (not (string-match "go" compile-command))
;;       (set (make-local-variable 'compile-command)
;;            "go generate && go build -v && go test -v && go vet"))
;;   ; Godef jump key binding
;;   (local-set-key (kbd "M-.") 'godef-jump)
;;   (local-set-key (kbd "M-*") 'pop-tag-mark)
;;   (local-set-key (kbd "C-c C-k") 'godoc)
;;   (add-hook 'before-save-hook 'gofmt-before-save)
;;   (setq tab-width 4 indent-tabs-mode 1))

;; (add-hook 'go-mode-hook 'go-eldoc-setup)
;; (add-hook 'go-mode-hook 'my-go-mode-hook)

;; (with-eval-after-load 'go-mode
;;   (require 'go-autocomplete)
;;   (ac-config-default))

;; (straight-use-package 'lsp-mode)
;; (add-hook 'go-mode-hook #'lsp-deferred)

;; ;; Set up before-save hooks to format buffer and add/delete imports.
;; ;; Make sure you don't have other gofmt/goimports hooks enabled.
;; (defun lsp-go-install-save-hooks ()
;;   (add-hook 'before-save-hook #'lsp-format-buffer t t)
;;   (add-hook 'before-save-hook #'lsp-organize-imports t t))

;; (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

(straight-use-package 'lsp-mode)
(add-hook 'go-mode-hook #'lsp-deferred)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))

(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)


(use-package go-mode
  :straight t
  :bind (:map go-mode-map
	      ("TAB" . company-indent-or-complete-common)
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-signature-auto-activate nil)

  ;; uncomment for plain lsp

  (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-doc-show-with-cursor nil)
  (setq lsp-ui-doc-show-with-mouse nil)

  (setq lsp-ui-sideline-enable nil)
  (setq lsp-ui-sideline-show-code-actions nil)
  (setq lsp-ui-sideline-enable nil)
  (setq lsp-ui-sideline-show-hover nil)
  (setq lsp-ui-sideline-enable nil)
  (setq lsp-ui-sideline-show-diagnostics nil)

  (setq lsp-lens-enable nil)
  (setq lsp-headerline-breadcrumb-enable nil)

  ;; (setq lsp-diagnostics-provider :none)

  (setq lsp-eldoc-enable-hover nil)

  (setq lsp-modeline-diagnostics-enable nil)
  (setq lsp-modeline-code-actions-enable nil)
  ;; (setq lsp-rust-target-dir "~/.cargo/target")


  (setq lsp-signature-auto-activate nil) ;; you could manually request them via `lsp-signature-activate`
  (setq lsp-signature-render-documentation nil)

  ;; (setq lsp-completion-provider :none)
  (setq lsp-completion-show-detail nil)
  ;; (setq lsp-completion-show-kind nil)


  (add-hook 'go-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'go-mode-hook 'rk/go-mode-hook))

(defun rk/go-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm, but don't try to
  ;; save rust buffers that are not file visiting. Once
  ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
  ;; no longer be necessary.
  (when buffer-file-name
    (setq-local buffer-save-without-query t)))

(use-package lsp-mode
  :straight t
  :commands lsp
  :custom
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  ;; (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all nil)
  (lsp-idle-delay 1)
  (lsp-rust-analyzer-server-display-inlay-hints nil)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-ui
  :straight t
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show nil)
  (lsp-ui-sideline-show-hover nil)
  (lsp-ui-doc-enable nil))

(use-package company
  :straight t
  :custom
  (company-idle-delay 0.5) ;; how long to wait until popup
  ;; (company-begin-commands nil) ;; uncomment to disable popup
  :bind
  (:map company-active-map
	("C-n". company-select-next)
	("C-p". company-select-previous)
	("M-<". company-select-first)
	("M->". company-select-last)))

;; (use-package company
;;   ;; ... see above ...
;;   (:map company-mode-map
;; 	("<tab>". tab-indent-or-complete)
;; 	("TAB". tab-indent-or-complete)))


(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (check-expansion)
	(company-complete-common)
      (indent-for-tab-command))))

(use-package flycheck :straight t)
(use-package flycheck-rust :straight t)

(use-package exec-path-from-shell
  :straight t
  :init (exec-path-from-shell-initialize))


(provide 'init-go)
