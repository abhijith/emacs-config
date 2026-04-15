(use-package rust-mode
  :straight t
  :init

  (defun my-try-expand-lsp-smart (old)
  "Succinct LSP expansion: 1 match = expand; >1 = minibuffer; 0 = fail."
  (unless old
    (let ((capf (run-hook-with-args-until-success 'completion-at-point-functions)))
      (when (and (listp capf) (nth 2 capf))
        (let* ((beg (nth 0 capf)) (end (nth 1 capf)) (table (nth 2 capf))
               (prefix (buffer-substring-no-properties beg end))
               (result (try-completion prefix table)))
          (cond
           ((stringp result) (completion-at-point)) ; Multiple matches -> UI
           ((eq result t) (completion-at-point))    ; Unique match -> Expand
           (t nil))))))                             ; No match -> Fail
  nil) ; Always return nil to prevent hippie-expand from trying to "cycle"


  :hook ((rust-mode . lsp-deferred)
         (rust-mode . rainbow-delimiters-mode))

  :config
  (setq rust-rustfmt-bin "rustup"
	rust-format-on-save t
        rust-rustfmt-switches '("run" "nightly" "rustfmt"))
  (setq completion-category-overrides
	'((lsp-capf (styles . (basic))))) ; 'basic' is prefix-only, no fuzzy.
  :bind (:map rust-mode-map
  ;; so that run C-c C-c C-r works without having to confirm, but don't try to
  ;; save rust buffers that are not file visiting. Once
  ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
  ;; no longer be necessary.
              ("M-n"   . flymake-goto-next-error)
              ("M-p"   . flymake-goto-prev-error)
              ("C-c C-d" . lsp-describe-thing-at-point)

	      ;; ("M-TAB" . completion-at-point)
              ("M-TAB" . hippie-expand)
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)

              ("C-c C-c l" . flymake-show-buffer-diagnostics)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))

  :config

(add-hook 'rust-mode-hook
          (lambda ()
            ;; Set the list to EXACTLY one function.
            ;; No filenames, no lines, no buffer text.
            (setq-local hippie-expand-try-functions-list
                        '(my-try-expand-lsp-smart))))

  ;; Optional: If you want it to fall back to buffer text if LSP fails:
  ;; (setq-local hippie-expand-try-functions-list '(my-try-expand-lsp try-expand-dabbrev))
  (setq lsp-rust-analyzer-completion-postfix-enable nil) ; Disable postfix (e.g., .if -> if)
  (setq lsp-prefer-capf t)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-signature-auto-activate nil)

  ;; uncomment for plain lsp

  (setq lsp-enable-symbol-highlighting nil)

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

  (setq lsp-diagnostics-provider :none)

  (setq lsp-eldoc-enable-hover nil)

  (setq lsp-modeline-diagnostics-enable nil)
  (setq lsp-modeline-code-actions-enable nil)
  (setq lsp-rust-target-dir "~/.cargo/target")


  (setq lsp-signature-auto-activate nil) ;; you could manually request them via `lsp-signature-activate`
  (setq lsp-signature-render-documentation nil)

  (setq lsp-completion-provider :none)
  (setq lsp-completion-show-detail nil)
  (setq lsp-completion-show-kind nil)

  ;; comment to disable rustfmt on save
  (setq rust-format-on-save t)
  (setq lsp-rust-analyzer-proc-macro-enable nil)
  (add-hook 'rust-mode-hook 'rainbow-delimiters-mode))


(use-package lsp-mode
  :straight t
  :commands lsp
  :custom
  ;; what to use when checking on-save. "check" is default
  (lsp-rust-analyzer-cargo-watch-command "check")
  (lsp-eldoc-render-all nil)
  (lsp-idle-delay -1)
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

(use-package exec-path-from-shell
  :straight t
  :init (exec-path-from-shell-initialize))

(provide 'init-rust-lsp)
