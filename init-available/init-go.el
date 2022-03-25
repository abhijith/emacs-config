;; (require 'packages)

;; go-autocomplete dependency
;; go get -u github.com/mdempsky/gocode

;; go get github.com/rogpeppe/godef

;; go imports
;; go get golang.org/x/tools/cmd/goimports

(straight-use-package 'go-mode)
(straight-use-package 'go-autocomplete)
(straight-use-package 'go-errcheck)
(straight-use-package 'go-eldoc)
(straight-use-package 'protobuf-mode)

(defun my-go-mode-hook ()
  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go generate && go build -v && go test -v && go vet"))
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
  (local-set-key (kbd "C-c C-k") 'godoc)
  (add-hook 'before-save-hook 'gofmt-before-save)
  (setq tab-width 4 indent-tabs-mode 1))

(add-hook 'go-mode-hook 'go-eldoc-setup)
(add-hook 'go-mode-hook 'my-go-mode-hook)

(with-eval-after-load 'go-mode
  (require 'go-autocomplete)
  (ac-config-default))

(provide 'init-go)
