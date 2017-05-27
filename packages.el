(require 'package)

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)
(when (not (file-exists-p "~/.emacs.d/elpa/archives"))
  (package-refresh-contents))

(defun install-packages (my-packages)
  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p))))

(provide 'packages)
