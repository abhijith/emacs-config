(progn
  (add-to-list 'load-path (expand-file-name "~/.emacs.d") t)
  (add-to-list 'load-path (expand-file-name "~/.emacs.d/init-enabled") t)
  (add-to-list 'load-path (expand-file-name "~/.emacs.d/themes") t)
  (add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

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
  (blink-cursor-mode -1)
  (recentf-mode 0)

  (mapc (lambda (name)
	  (load-file (concat "~/.emacs.d/init.d/" name)))
	(directory-files "~/.emacs.d/init.d" nil "\\.el$"))

  (setq custom-file "~/.emacs.d/emacs-custom.el")
  (when (file-exists-p custom-file)
    (load custom-file))

  (setq user-specific-config (concat "~/.emacs.d/" user-login-name ".el"))
  (if (file-exists-p user-specific-config)
      (load user-specific-config)))
