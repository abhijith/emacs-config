(use-package haskell-mode :ensure t)
(use-package company :ensure t)

(add-hook 'haskell-mode-hook 'company-mode)
(add-hook 'haskell-mode-hook 'haskell-indent-mode)

(provide 'init-haskell)
