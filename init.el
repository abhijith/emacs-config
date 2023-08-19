;;; install and initialize straight
(defvar bootstrap-version)

(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;; start customizations

(straight-use-package 'use-package)
(straight-use-package 'alert)
(straight-use-package 'company-mode)
(straight-use-package 'queue)


(add-to-list 'load-path (expand-file-name "~/.emacs.d/init-enabled") t)
(add-to-list 'load-path (expand-file-name "~/.emacs.d/themes") t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(add-to-list 'custom-theme-load-path "themes")
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(set-language-environment "utf-8")

(setq
 frame-title-format '(buffer-file-name "%f" ("%b"))
 indent-tabs-mode nil
 inhibit-startup-screen t
 visible-bell nil
 echo-keystrokes 0.1
 font-lock-maximum-decoration t
 inhibit-startup-message t
 transient-mark-mode t
 shift-select-mode nil
 mouse-yank-at-point t
 require-final-newline t
 truncate-partial-width-windows nil
 uniquify-buffer-name-style 'forward)

(tooltip-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(show-paren-mode 1)
(mouse-wheel-mode t)
(blink-cursor-mode t)
(recentf-mode 0)
(setq backup-directory-alist `(("." . "~/.emacs.d/.saves")))
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(setq custom-file "~/.emacs.d/emacs-custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

(progn
  (load-theme 'dusk)
  (set-face-attribute 'default nil :height 92))

;; Simple package names
(progn
  (straight-use-package 'escreen)
  (load "escreen")
  (escreen-install)
  (global-set-key (kbd "M-1") 'escreen-goto-screen-0)
  (global-set-key (kbd "M-2") 'escreen-goto-screen-1)
  (global-set-key (kbd "M-3") 'escreen-goto-screen-2)
  (global-set-key (kbd "M-4") 'escreen-goto-screen-3)
  (global-set-key (kbd "M-5") 'escreen-goto-screen-4)
  (global-set-key [S-right] 'escreen-goto-next-screen)
  (global-set-key [S-left]  'escreen-goto-prev-screen))


(mapc (lambda (name)
        (require (intern (file-name-sans-extension name))))
      (directory-files "~/.emacs.d/init-enabled" nil "\\.el$"))

(put 'upcase-region 'disabled nil)

(setq auto-save-default nil)
(setq create-lockfiles nil)

(use-package shell-pop
  :straight t
  :bind (("C-t" . shell-pop))
  :config
  (setq shell-pop-shell-type (quote ("ansi-term" "*ansi-term*" (lambda nil (ansi-term shell-pop-term-shell)))))
  (setq shell-pop-term-shell "/bin/bash")
  ;; need to do this manually or not picked up by `shell-pop'
  (shell-pop--set-shell-type 'shell-pop-shell-type shell-pop-shell-type))

(use-package rainbow-delimiters
  :straight t)

(use-package which-key
  :straight t

  ;; Allow C-h to trigger which-key before it is done automatically
  :config (setq which-key-show-early-on-C-h t)
  ;; make sure which-key doesn't show normally but refreshes quickly after it is
  ;; triggered.
  (setq which-key-idle-delay 10000)
  (setq which-key-idle-secondary-delay 0.05)
  (which-key-mode))


;; ;;;;;;;;;;; rust-mode

;; (use-package rust-mode
;;   :straight t
;;   :mode ("\\.rs$" . rust-mode)
;;   :config
;;   (progn
;;     (electric-indent-mode 0)
;;     (setq rust-format-on-save t)
;;     (add-hook 'rust-mode-hook
;; 	      (lambda ()
;; 		(setq indent-tabs-mode nil)
;; 		(setq prettify-symbols-alist
;; 		      '(("fn" . 955)
;; 			("->" . 8594))))))
;;   :bind
;;   (:map rust-mode-map
;; 	("C-c C-c" . rust-compile)
;; 	("C-c C-l" . rust-run-clippy)
;; 	("C-c C-d" . eldoc-print-current-symbol-info)))


;; (use-package xref
;;   :straight t
;;   :bind (("M-." . #'xref-find-definitions)
;;          ("M-/" . #'xref-go-back)
;;          ("M-r" . #'xref-find-references)))

;; (use-package eglot
;;   :straight t
;;   :config
;;   (setq eglot-send-changes-idle-time (* 60 60))
;;   (add-to-list 'eglot-stay-out-of 'flymake)
;;   (add-hook 'eglot-managed-mode-hook (lambda ()
;; 				       (eldoc-mode 1)
;; 				       (flymake-mode 1))))

;; (defclass eglot-rust-x-analyzer (eglot-lsp-server) ()
;;   :documentation "A custom class for rust-analyzer.")

;; (cl-defmethod eglot-initialization-options ((server eglot-rust-x-analyzer))
;;   '(:rust-analyzer
;;     ( :procMacro ( :attributes (:enable t)
;; 		   :enable t)
;;       :cargo (:buildScripts (:enable t))
;;       :diagnostics (:disabled ["unresolved-proc-macro"
;; 			       "unresolved-macro-call"]))))

;; (add-to-list 'eglot-server-programs
;;              '(rust-mode . (eglot-rust-x-analyzer "rust-analyzer" "-v"
;; 						  "--log-file" "/tmp/ra.log")))

;; (defun eglot-connect ()
;;   (interactive)
;;   (eglot-ensure))


;; expanding

;; (defvar mode-specified-try-functions-table (make-hash-table))

;; (defun set-mode-specified-try-functions (mode functions)
;;   (setf (gethash mode mode-specified-try-functions-table)
;; 	functions))

;; (defun set-default-try-functions (functions)
;;   (setf (gethash :default mode-specified-try-functions-table)
;; 	functions))

;; (defun expand-try-functions-of (mode)
;;   (let ((result
;; 	 (gethash mode mode-specified-try-functions-table)))
;;     (if (listp result) result
;;       (list result))))

;; (defun current-hippie-expand-try-function-list ()
;;   (remove-duplicates
;;    (remove nil
;; 	   (append
;; 	    (apply
;; 	     'append
;; 	     (mapcar 'expand-try-functions-of minor-mode-list))
;; 	    (expand-try-functions-of major-mode)
;; 	    (expand-try-functions-of :default)))
;;    :from-end t))

;; (defadvice hippie-expand (around mode-specified-hippie-expand)
;;   (let ((hippie-expand-try-functions-list
;; 	 (current-hippie-expand-try-function-list)))
;;     ad-do-it))

;; (defun enable-mode-specified-hippie-expand ()
;;   (interactive)
;;   (ad-enable-advice 'hippie-expand
;; 		    'around
;; 		    'mode-specified-hippie-expand)
;;   (ad-activate 'hippie-expand))

;; (defun disable-mode-specified-hippie-expand ()
;;   (interactive)
;;   (ad-disable-advice 'hippie-expand
;; 		     'around
;; 		     'mode-specified-hippie-expand)
;;   (ad-deactivate 'hippie-expand))

;; (set-default-try-functions
;;  '(try-expand-dabbrev
;;    try-expand-all-abbrevs
;;    try-expand-dabbrev-all-buffers
;;    try-expand-list
;;    try-expand-line
;;    try-expand-dabbrev-from-kill))

;; (set-mode-specified-try-functions
;;  'emacs-lisp-mode
;;  '(try-complete-lisp-symbol-partially
;;    try-complete-lisp-symbol))

;; (defun tags-complete-tag (string predicate what)
;;   (save-excursion
;;     ;; If we need to ask for the tag table, allow that.
;;     (if (eq what t)
;; 	(all-completions string (tags-completion-table) predicate)
;;       (try-completion string (tags-completion-table) predicate))))


;; (defun he-tag-beg ()
;;   (let ((p
;;          (save-excursion
;;            (backward-word 1)
;;            (point))))
;;     p))

;; (defun try-expand-tag (old)
;;   (unless  old
;;     (he-init-string (he-tag-beg) (point))
;;     (setq he-expand-list (sort
;;                           (all-completions he-search-string 'tags-complete-tag) 'string-lessp)))
;;   (while (and he-expand-list
;;               (he-string-member (car he-expand-list) he-tried-table))
;;               (setq he-expand-list (cdr he-expand-list)))
;;   (if (null he-expand-list)
;;       (progn
;;         (when old (he-reset-string))
;;         ())
;;     (he-substitute-string (car he-expand-list))
;;     (setq he-expand-list (cdr he-expand-list))
;;     t))


;; (global-set-key [remap dabbrev-expand] 'hippie-expand)

;; (defun smart-tab ()
;;   (interactive)
;;   (if (minibufferp)
;;       (unless (minibuffer-complete)
;;         (hippie-expand nil))
;;     (if mark-active
;;         (indent-region (region-beginning)
;;                        (region-end))
;;       (if (looking-at "\\_>")
;;           (hippie-expand nil)
;;         (indent-for-tab-command)))))
;; (global-set-key (kbd "TAB") 'smart-tab)

;; (use-package wdired
;;   :straight t
;;   :init
;;   (require 'highline)
;;   :bind (:map dired-mode-map
;; 	      ("r" . wdired-change-to-wdired-mode))
;;   :config
;;   (setq directory-sep-char ?/)
;;   (add-hook 'dired-load-hook
;; 	    (lambda ()
;; 	      (load "dired-x")
;; 	      (setq directory-sep-char ?/
;; 		    wdired-allow-to-change-permissions t
;; 		    dired-backup-overwrite t)))
;;   (add-hook 'dired-mode-hook #'highline-mode-on))

(use-package dired-details
  :straight t
  :config
  (bind-key (kbd "C-x C-d") 'dired)
  (setq dired-details-hidden-string ""
	dired-dwim-target t
	dired-details-initially-hide t)
  (add-hook 'dired-mode-hook #'dired-details-install))

(use-package dired-subtree
  :straight t
  :bind (:map dired-mode-map
	      ("<tab>" . dired-subtree-cycle)
	      ("i" . dired-subtree-insert)
	      ("k" . dired-subtree-remove))
  :config
  (setq dired-subtree-line-prefix
	(lambda (depth) (make-string (* 2 depth) ?\s)))
  (setq dired-subtree-use-backgrounds nil))

(defun dired-lynx-keybindings ()
  (define-key dired-mode-map [left]  'dired-up-directory)
  (define-key dired-mode-map [right] 'dired-view-file))
(add-hook 'dired-mode-hook 'dired-lynx-keybindings)
(add-hook 'dired-mode-hook #'highline-mode-on)



(use-package align
  :straight t
  :bind (("M-["   . align-code)
         ("C-c [" . align-regexp))
  :commands align
  :preface
  (defun align-code (beg end &optional arg)
    (interactive "rP")
    (if (null arg)
        (align beg end)
      (let ((end-mark (copy-marker end)))
        (indent-region beg end-mark nil)
        (align beg end-mark)))))


(use-package ace-window
  :straight t
  :config
  (bind-key "C-x o" 'ace-window))


(use-package smart-mode-line
  :straight t
  :init
  (sml/setup)
  (setq sml/no-confirm-load-theme t
	sml/vc-mode-show-backend t
	resize-mini-windows nil)
  (sml/apply-theme nil)
  :config
  (dolist (m '("AC" "Undo-Tree" "ARev" "Anzu" "Guide" "company"))
    (add-to-list 'sml/hidden-modes (concat " " m))))

(use-package magit
  :straight t
  :init
  (progn
    (add-to-list 'auto-mode-alist '("COMMIT_EDITMSG$" . diff-mode)))
  :config
  (setq magit-auto-revert-mode 1
	magit-last-seen-setup-instructions "1.4.0"
	diff-switches "-u"
	magit-push-always-verify nil
	magit-git-executable "git"
	magit-save-repository-buffers 'dontask
	magit-default-tracking-name-function
	#'magit-default-tracking-name-branch-only)
  (add-hook 'magit-mode-hook #'highline-mode-on)
  (setq magit-repolist-columns
	'(("Name"       25  magit-repolist-column-ident nil)
          ("Branch"     10  magit-repolist-column-branch)
          ("Version"    25  magit-repolist-column-version nil)
          ("↓P"         5   magit-repolist-column-unpulled-from-pushremote)
          ("↑P"         5   magit-repolist-column-unpushed-to-pushremote)
          (""           6   magit-repolist-column-dirty)
          ("Path"       99  magit-repolist-column-path nil)))
  :bind
  (("C-c m" . magit-status)
   ("C-c l" . magit-log-buffer-file)
   ("C-c L" . magit-log-head)
   ("C-c o" . magit-checkout)
   ("C-c d" . magit-diff-buffer-file)
("C-c D" . magit-diff)))

(use-package magit-filenotify
  :straight t
  :config
  (add-hook 'magit-status-mode-hook 'magit-filenotify-mode))

;; mastering emacs

(global-set-key (kbd "M-o") 'other-window)

(windmove-default-keybindings 'meta)

(use-package beacon
  :straight t
  :config (beacon-mode t))
