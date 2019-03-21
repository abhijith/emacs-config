
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(progn
  (add-to-list 'load-path (expand-file-name "~/.emacs.d/init-enabled") t)
  (add-to-list 'load-path (expand-file-name "~/.emacs.d/themes") t)
  (add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp") t)
  (add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
  (add-to-list 'default-frame-alist '(fullscreen . maximized))

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

  (mapc (lambda (name)
	  (require (intern (file-name-sans-extension name))))
	(directory-files "~/.emacs.d/init-enabled" nil "\\.el$"))
  (setq custom-file "~/.emacs.d/emacs-custom.el")
  (when (file-exists-p custom-file)
    (load custom-file))
  (load-theme 'dusk)
  (put 'upcase-region 'disabled nil)
  (set-face-attribute 'default nil :height 95))

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

;; Simple package names
(el-get-bundle escreen
;; escreen
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

;; ;; Locally defined recipe
;; (el-get-bundle escreen
;;   :url "http://www.splode.com/~friedman/software/emacs-lisp/src/escreen.el")


;; ;; With initialization code
;; (el-get-bundle zenburn-theme
;;   :url "https://raw.githubusercontent.com/bbatsov/zenburn-emacs/master/zenburn-theme.el"
;;   (load-theme 'zenburn t))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")

;; (dracula-theme yaml-mode csv-mode boxquote textile-mode toml-mode cargo flycheck-rust racer rust-mode json-mode haskell-mode go-eldoc go-errcheck go-autocomplete go-complete go-mode dired-details highline paredit ac-cider cider clojure-mode zenburn-theme bubbleberry-theme jump powerline company)
