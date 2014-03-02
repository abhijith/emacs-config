(require 'packages)
(install-packages '(tuareg
                    auto-complete))

(defvar opam-prefix-path "/usr/local/bin/opam config var prefix")
(defvar opam-share-path "/usr/local/bin/opam config var share")
(defvar opam-bin-path "/usr/local/bin/opam config var bin")

(add-to-list 'auto-mode-alist '("\\.ml[iylp]?" . tuareg-mode))
(autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
(autoload 'camldebug "camldebug" "Run the Caml debugger" t)

(add-to-list 'auto-mode-alist '("\\.ml[iylp]?" . tuareg-mode))
(dolist (ext '(".cmo" ".cmx" ".cma" ".cmxa" ".cmi"))
  (add-to-list 'completion-ignored-extensions ext))

(load-file
 (concat
  (substring
   (shell-command-to-string opam-prefix-path) 0 -1)
  "/share/typerex/ocp-indent/ocp-indent.el"))

;; merlin
(setq opam-share
      (substring
       (shell-command-to-string opam-share-path) 0 -1))

(add-to-list 'load-path (concat opam-share "/emacs/site-lisp"))

(require 'merlin)

(setq merlin-command
      (concat
       (substring
        (shell-command-to-string opam-bin-path) 0 -1)
       "/ocamlmerlin"))

(setq ocp-indent-path
      (concat
       (substring (shell-command-to-string opam-bin-path) 0 -1)
       "/ocp-indent"))


(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(require 'auto-complete-config)
(ac-config-default)
(setq merlin-use-auto-complete-mode t)

;; utop
(autoload 'utop "utop" "Toplevel for OCaml" t)
(autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
(add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)

(mapc
 (lambda (line)
   (when (string-match "\\(.*\\)=\\(.*\\)" line)
     (setenv (match-string 1 line) (match-string 2 line))))
 (split-string
  (shell-command-to-string "/usr/local/bin/opam config -env")
  ";[ \r\n\t]*"))

(setq utop-command
      (concat
       (substring (shell-command-to-string opam-bin-path) 0 -1)
       "/utop" " " "-emacs"))


;; some pretty symbols
 (defun unicode-symbol (name)
    "Translate a symbolic name for a Unicode character -- e.g., LEFT-ARROW
  or GREATER-THAN into an actual Unicode character code. "
    (decode-char 'ucs (case name
                        ;; arrows
                        ('left-arrow 8592)
                        ('up-arrow 8593)
                        ('right-arrow 8594)
                        ('down-arrow 8595)
                        ;; boxes
                        ('double-vertical-bar #X2551)
                        ;; relational operators
                        ('equal #X003d)
                        ('not-equal #X2260)
                        ('identical #X2261)
                        ('not-identical #X2262)
                        ('less-than #X003c)
                        ('greater-than #X003e)
                        ('less-than-or-equal-to #X2264)
                        ('greater-than-or-equal-to #X2265)
                        ;; logical operators
                        ('logical-and #X2227)
                        ('logical-or #X2228)
                        ('logical-neg #X00AC)
                        ;; misc
                        ('nil #X2205)
                        ('horizontal-ellipsis #X2026)
                        ('double-exclamation #X203C)
                        ('prime #X2032)
                        ('double-prime #X2033)
                        ('for-all #X2200)
                        ('there-exists #X2203)
                        ('element-of #X2208)
                        ;; mathematical operators
                        ('square-root #X221A)
                        ('squared #X00B2)
                        ('cubed #X00B3)
                        ;; letters
                        ('lambda #X03BB)
                        ('alpha #X03B1)
                        ('beta #X03B2)
                        ('gamma #X03B3)
                        ('delta #X03B4))))

  (defun substitute-pattern-with-unicode (pattern symbol)
    "Add a font lock hook to replace the matched part of PATTERN with the
  Unicode symbol SYMBOL looked up with UNICODE-SYMBOL."
    (interactive)
    (font-lock-add-keywords
     nil `((,pattern (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                              ,(unicode-symbol symbol))
                              nil))))))

  (defun substitute-patterns-with-unicode (patterns)
    "Call SUBSTITUTE-PATTERN-WITH-UNICODE repeatedly."
    (mapcar #'(lambda (x)
                (substitute-pattern-with-unicode (car x)
                                                 (cdr x)))
            patterns))

(defun ocaml-unicode ()
  (interactive)
  (substitute-patterns-with-unicode
   (list (cons "\\(<-\\)" 'left-arrow)
         (cons "\\(->\\)" 'right-arrow)
	 (cons "\\(fun\\)" 'lambda)
         (cons "\\[^=\\]\\(=\\)\\[^=\\]" 'equal)
         (cons "\\(==\\)" 'identical)
         (cons "\\(\\!=\\)" 'not-identical)
         (cons "\\(<>\\)" 'not-equal)
         (cons "\\(()\\)" 'nil)
         (cons "\\<\\(sqrt\\)\\>" 'square-root)
         (cons "\\(&&\\)" 'logical-and)
         (cons "\\(||\\)" 'logical-or)
         (cons "\\<\\(not\\)\\>" 'logical-neg)
         (cons "\\(>\\)\\[^=\\]" 'greater-than)
         (cons "\\(<\\)\\[^=\\]" 'less-than)
         (cons "\\(>=\\)" 'greater-than-or-equal-to)
         (cons "\\(<=\\)" 'less-than-or-equal-to)
         (cons "\\<\\(alpha\\)\\>" 'alpha)
         (cons "\\<\\(beta\\)\\>" 'beta)
         (cons "\\<\\(gamma\\)\\>" 'gamma)
         (cons "\\<\\(delta\\)\\>" 'delta)
         (cons "\\(''\\)" 'double-prime)
         (cons "\\('\\)" 'prime)
         (cons "\\<\\(List.for_all\\)\\>" 'for-all)
         (cons "\\<\\(List.exists\\)\\>" 'there-exists)
         (cons "\\<\\(List.mem\\)\\>" 'element-of)
         (cons "^ +\\(|\\)" 'double-vertical-bar))))

(defun ocp-indent-buffer ()
  (interactive nil)
  (ocp-indent-region (point-min) (point-max)))

(defun repl-hooks()
  (auto-highlight-symbol-mode)
  (autopair-mode)
  (rainbow-delimiters-mode))

(defun ocaml-hooks()
  (local-set-key (kbd "M-e") 'tuareg-eval-buffer)
  (local-set-key (kbd "M-/") 'utop-edit-complete)
  (local-set-key (kbd "M-q") 'ocp-indent-buffer)
  (local-set-key (kbd "M-n") 'merlin-phrase-next)
  (local-set-key (kbd "M-p") 'merlin-phrase-prev)
  (local-set-key (kbd "M-t") 'merlin-type-enclosing)
  (local-set-key (kbd "M-l") 'merlin-locate))

(add-hook 'tuareg-mode-hook
          '(lambda ()
             (merlin-mode)
             (ocaml-unicode)
             (ocaml-hooks)
             (setq compile-command
                   (concat "corebuild -pkg core "
                           (file-name-sans-extension buffer-file-name)
                           ".byte"))
             (setq indent-line-function 'ocp-indent-line)
             (setq merlin-use-auto-complete-mode t)))
