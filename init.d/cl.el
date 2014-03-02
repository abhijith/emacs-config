(require 'packages)

(install-packages '(slime
                    paredit
                    parenface
                    paredit))

(define-key read-expression-map (kbd "TAB") 'lisp-complete-symbol)
(define-key lisp-mode-shared-map (kbd "C-c l") "lambda")
(define-key lisp-mode-shared-map (kbd "RET") 'reindent-then-newline-and-indent)
(define-key lisp-mode-shared-map (kbd "C-c v") 'eval-buffer)

(require 'parenface)

(require 'paredit)
(paredit-mode 1)

(require 'slime)

(slime-setup '(slime-tramp
               slime-asdf
               slime-banner
               slime-fuzzy))
(setq
 inferior-lisp-program "/usr/local/bin/sbcl"
 slime-complete-symbol-function 'slime-fuzzy-complete-symbol
 slime-startup-animation t)

(slime-require :swank-listener-hooks)
