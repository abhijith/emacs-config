(use-package exec-path-from-shell
  :init (exec-path-from-shell-initialize))

(setq completion-styles '(basic partial-completion))

(defun my/tab-indent-or-complete ()
  (interactive)
  (or (completion-at-point)
      (indent-for-tab-command)))

(use-package flymake
  :ensure nil
  :custom
  (flymake-no-changes-timeout nil)
  (flymake-start-on-flymake-mode t)
  (flymake-start-on-save-buffer t))


(use-package rust-mode
  :mode "\\.rs\\'"
  :hook
  ((rust-mode . eglot-ensure)
   (rust-mode . rainbow-delimiters-mode)
   (rust-mode . superword-mode))
  :bind
  (:map rust-mode-map
        ("M-TAB" . my/tab-indent-or-complete)
        ("M-n" . flymake-goto-next-error)
        ("M-p" . flymake-goto-prev-error)
        ("C-c C-c l" . flymake-show-buffer-diagnostics)
        ("C-c C-d" . eldoc-print-current-symbol-info))
  :config
  (add-hook 'eglot-managed-mode-hook #'flymake-mode)
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (setq-local flymake-no-changes-timeout nil)))

  (electric-indent-mode 0)
  (setq rust-format-on-save t
        indent-tabs-mode nil)

  (setq rust-rustfmt-bin "rustup"
        rust-rustfmt-switches '("run" "nightly" "rustfmt")))

(use-package xref
  :ensure nil
  :bind (("M-." . xref-find-definitions)
         ("M-," . xref-go-back)
         ("M-r" . xref-find-references)))

(use-package eglot
  :straight nil

  :ensure nil

  :hook
  ((rust-mode . eglot-ensure)
   (eglot-managed-mode . eldoc-mode)
   (eglot-managed-mode . flymake-mode)
   (rust-mode . my/rust-completion-ui-settings))

  :init
  (defun my/rust-analyzer-command (_interactive)
    (let* ((project (project-current))
           (root (when project (project-root project)))
           (name (if root (file-name-nondirectory (directory-file-name root)) "global"))
           (log (expand-file-name (format "ra-%s.log" name) temporary-file-directory))
           (settings '(:procMacro (:enable t :attributes (:enable t))
				  :cargo (:buildScripts (:enable t))
				  :diagnostics (:disabled ["unresolved-proc-macro" "unresolved-macro-call"])
				  :rustfmt (:overrideCommand ["rustup" "run" "nightly" "rustfmt"])
				  :inlayHints (:typeHints (:enable :json-false)
							  :parameterHints (:enable :json-false)
							  :chainingHints (:enable :json-false)
							  :closingBraceHints (:enable :json-false)
							  :lifetimeElisionHints (:enable :json-false)
							  :reborrowHints (:enable :json-false)))))
      (append (list "rust-analyzer" "-v" "--log-file" log)
              (list :initializationOptions settings))))


  (defun my/rust-completion-ui-settings ()
    "Set local completion style and window size for Rust."
    (setq-local completions-format 'one-column)
    (setq-local completions-detailed t)
    (setq-local display-buffer-alist
                (cons '("\\*Completions\\*"
                        (display-buffer-reuse-window display-buffer-at-bottom)
                        (window-height . 12)
                        (preserve-size . (nil . t)))
                      display-buffer-alist)))


  (with-eval-after-load 'eglot
    (setf (alist-get 'rust-mode eglot-server-programs) #'my/rust-analyzer-command))


  (with-eval-after-load 'rustic
    (define-key rustic-mode-map (kbd "M-j") 'imenu))

  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-size 0)
  (eglot-extend-to-xref nil)
  (eldoc-idle-delay 0.2)
  (eldoc-echo-area-use-multiline-p t)

  :config
  ;; fallback
  (setq eglot-workspace-configuration
        '(:rust-analyzer
          (:procMacro (:enable t)
		      :cargo (:buildScripts (:enable t))))))


;; (set-face-attribute 'flymake-error nil :underline '(:style wave :color "red"))
;; (set-face-attribute 'flymake-warning nil :underline '(:style wave :color "yellow"))

(provide 'init-rust-eglot)
