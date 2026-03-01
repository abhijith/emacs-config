(use-package rust-mode
  :straight t
  :init

  (defun my-try-expand-lsp-smart (old)
  "Hippie-expand:
If 1 match: Expand in-place.
If >1 match: Switch to minibuffer/UI.
If 0 matches: Fail."
  (unless old
    (he-init-string (he-dabbrev-beg) (point))
    (let ((capf-data (run-hook-with-args-until-success 'completion-at-point-functions)))
      (setq he-expand-list nil)
      (when (and (listp capf-data) (nth 2 capf-data))
        (let* ((table (nth 2 capf-data))
               (prefix (buffer-substring-no-properties (nth 0 capf-data) (nth 1 capf-data)))
               (candidates (all-completions prefix table)))

          (cond
           ;; Case A: Exact Single Match - Expand it.
           ((= (length candidates) 1)
            (setq he-expand-list candidates))

           ;; Case B: Ambiguity - Hand over to Minibuffer.
           ((> (length candidates) 1)
            (he-reset-string) ; Clean up hippie's internal state
            (completion-at-point) ; Trigger the standard UI
            (setq he-expand-list nil)) ; Stop hippie from cycling

           ;; Case C: No matches.
           (t (setq he-expand-list nil)))))))

  ;; Standard Hippie-expand boilerplate for the single-match case
  (if (null he-expand-list)
      nil
    (he-substitute-string (car he-expand-list))
    (setq he-expand-list nil) ; Clear it so it doesn't 'cycle' back to itself
    t))



  :hook ((rust-mode . lsp-deferred)
         (rust-mode . rainbow-delimiters-mode)
         (rust-mode . superword-mode))

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
              ("C-c C-d"   . lsp-describe-thing-at-point)

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
  (add-hook 'rust-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'rust-mode-hook #'(lambda () (flymake-mode nil))))


(use-package lsp-mode
  :straight t
  :commands lsp
  :custom
  ;; what to use when checking on-save. "check" is default
  ;; (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all nil)
  (lsp-idle-delay -1)
  (lsp-rust-analyzer-server-display-inlay-hints nil)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  (add-hook 'lsp-mode-hook #'(lambda () (flymake-mode nil))))

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
