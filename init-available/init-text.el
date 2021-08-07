(use-package yaml-mode :straight t)
(use-package json-mode :straight t)
(use-package boxquote :straight t)
(use-package csv-mode :straight t)
(use-package markdown-mode :straight t)

(straight-use-package '(tid-mode :type git :host github :repo "mwfogleman/tid-mode"))

(defun open-wiki ()
  "Opens a TiddlyWiki directory in Dired."
  (interactive)
  (dired "~/repo/tiddlers/"))

(defun browse-wiki ()
  "Opens TiddlyWiki in the browser."
  (interactive)
  (browse-url "127.0.0.1:8080/"))

;; This latter function may require specifying a browser:

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")

;; You can bind either of these functions with the global-set-key function:
(global-set-key (kbd "C-c w") 'open-wiki)

(provide 'init-text)
