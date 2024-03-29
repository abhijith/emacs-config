;;;;;;;; pre-requisites

;; rust-analyzer: https://rust-analyzer.github.io/manual.html#emacs
;; mkdir ~/.local/bin
;; curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
;; chmod +x ~/.local/bin/rust-analyzer

(use-package rustic
  :straight t
  :init (setq rustic-treesitter-derive t)
  :bind (:map rustic-mode-map
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
  ;; (setq lsp-signature-auto-activate nil)

  ;; uncomment for plain lsp

  ;; (setq lsp-enable-symbol-highlighting nil)

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

  (setq lsp-eldoc-enable-hover t)

  (setq lsp-modeline-diagnostics-enable nil)
  (setq lsp-modeline-code-actions-enable nil)
  ;; (setq lsp-rust-target-dir "~/.cargo/target")


  ;; (setq lsp-signature-auto-activate nil) ;; you could manually request them via `lsp-signature-activate`
  ;; (setq lsp-signature-render-documentation nil)

  ;; (setq lsp-completion-provider :none)
  (setq lsp-completion-show-detail nil)
  ;; (setq lsp-completion-show-kind nil)


  ;; comment to disable rustfmt on save
  (setq rustic-format-on-save t)
  (add-hook 'rustic-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(defun rk/rustic-mode-hook ()
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

;; (use-package flycheck :straight t)
;; (use-package flycheck-rust :straight t)

;; (add-hook 'rustic-mode-hook #'flycheck-mode)
;; (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)


;; (with-eval-after-load 'rustic-mode
;;   (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(flycheck-mode nil)

(use-package exec-path-from-shell
  :straight t
  :init (exec-path-from-shell-initialize))

(use-package dap-mode
  :straight t
  :config
  (dap-ui-mode)
  (dap-ui-controls-mode 1)

  (require 'dap-lldb)
  (require 'dap-gdb-lldb)
  ;; installs .extension/vscode
  (dap-gdb-lldb-setup)
  (dap-register-debug-template
   "Rust::LLDB Run Configuration"
   (list :type "lldb"
         :request "launch"
         :name "LLDB::Run"
	 :gdbpath "rust-lldb"
         :target nil
         :cwd nil)))

(provide 'init-rustic)
