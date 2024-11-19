;; for hive
(use-package hive :straight t)

(add-to-list 'auto-mode-alist '("\\.hql\\'" . sql-mode))
(add-to-list 'auto-mode-alist '("\\.q\\'" . sql-mode))
(autoload 'sql-mode "sql-mode" "SQL editing mode." t)

(provide 'init-sql)
