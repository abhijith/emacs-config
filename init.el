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
  (global-set-key [S-left]  'escreen-goto-prev-screen)

  (global-set-key [C-right] 'escreen-goto-next-screen)
  (global-set-key [C-left]  'escreen-goto-prev-screen))


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
