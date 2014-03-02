;; for hive
(require 'packages)
(install-packages '(hive))

(add-to-list 'auto-mode-alist '("\\.hql\\'" . sql-mode))
(add-to-list 'auto-mode-alist '("\\.q\\'" . sql-mode))
(autoload 'sql-mode "sql-mode" "SQL editing mode." t)
