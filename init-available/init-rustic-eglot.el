(use-package rustic
  :straight t
  :init
  (setq rustic-treesitter-derive t)
  (setq rustic-lsp-client 'eglot) ;; Tell rustic to use eglot
  :bind (:map rustic-mode-map
              ("TAB" . company-indent-or-complete-common)
              ("M-j" . imenu)                   ;; Repl. lsp-ui-imenu (Listing)
              ("M-?" . xref-find-references)    ;; Repl. lsp-find-references
              ("C-c C-c l" . flymake-show-buffer-diagnostics) ;; Repl. flycheck-list
              ("C-c C-c a" . eglot-code-actions) ;; Repl. lsp-execute-code-action
              ("C-c C-c r" . eglot-rename)      ;; Repl. lsp-rename
              ("C-c C-c q" . eglot-reconnect)   ;; Repl. lsp-workspace-restart
              ("C-c C-c Q" . eglot-shutdown)    ;; Repl. lsp-workspace-shutdown
              ("C-c C-c s" . eglot-show-workspace-configuration)) ;; Closest to status
  :config
  ;; Neutral behavior: Manual docs
  (setq eglot-send-changes-idle-time 0.5)
  (setq eglot-autoshutdown t)

  (add-hook 'rustic-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

;; Eglot core setup (Built-in to Emacs 29+)
(use-package eglot
  :ensure nil ;; Built-in
  :custom
  (eglot-events-buffer-size 0) ;; Successor to lsp-mode noise reduction
  (eglot-extend-to-xref t)
  :config
  ;; Disable manual confirmations for cleaner flow
  (add-to-list 'eglot-server-programs
               `(rustic-mode . ("rust-analyzer" :initializationOptions
                                (:check (:command "clippy")
                                 :procMacro (:enable :json-false))))))

;; Eldoc: The built-in documentation handler
(use-package eldoc
  :ensure nil
  :custom
  (eldoc-echo-area-use-multiline-p nil) ;; Keeps signature in echo area
  (eldoc-idle-delay 0.5))

(provide 'init-rustic-eglot)
