(require 'packages)

;; go-autocomplete dependency -> $ go get -u github.com/mdempsky/gocode

;; $ go get github.com/rogpeppe/godef
;; go imports ->  go get golang.org/x/tools/cmd/goimports

(install-packages '(go-mode go-complete go-autocomplete go-errcheck go-eldoc))

(require 'go-mode)

(defun my-go-mode-hook ()
  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go generate && go build -v && go test -v && go vet"))
  ; Go Guru
  ;; (load-file "$GOPATH/src/golang.org/x/tools/cmd/guru/oracle.el")
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
  (local-set-key (kbd "C-c C-k") 'godoc)
  (add-hook 'before-save-hook 'gofmt-before-save)
  (setq tab-width 4 indent-tabs-mode 1))

(defun auto-complete-for-go ()
  (auto-complete-mode 1))

(require 'go-eldoc)
(add-hook 'go-mode-hook 'go-eldoc-setup)

(add-hook 'go-mode-hook 'my-go-mode-hook)

(with-eval-after-load 'go-mode
  (require 'go-autocomplete)
  (ac-config-default))

(provide 'init-go)
