(el-get-bundle json-mode)
(use-package json-mode)

(setq auto-mode-alist (cons '("\\.json\\'" . json-mode) auto-mode-alist))

(defun beautify-json ()
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max))))
    (shell-command-on-region b e
     "python -c 'import sys,json; data=json.loads(sys.stdin.read()); print json.dumps(data,sort_keys=True,indent=4).decode(\"unicode_escape\").encode(\"utf8\",\"replace\")'" (current-buffer) t)))

(define-key json-mode-map (kbd "C-c C-f") 'beautify-json)

(provide 'init-json)
