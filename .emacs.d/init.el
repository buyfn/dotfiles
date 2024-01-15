;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

;;; Code:
(package-initialize)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(require 'js2-refactor)
(require 'js-comint)
(require 'flycheck)

(setq completion-ignore-case t)

; run js2-mode for js files
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'js2-mode-hook #'js2-refactor-mode)
(setq js2-skip-preprocessor-directives t)
(js2r-add-keybindings-with-prefix "C-c C-r")

(add-hook 'after-init-hook #'global-flycheck-mode)
(setq-default flycheck-temp-prefix ".flycheck")
(setq-default flycheck-disabled-checkers
	      (append flycheck-disabled-checkers
		      '(javascript-jshint javascript-standard)))

(defun js2-mode-use-eslint-indent ()
  (let ((json-object-type 'hash-table)
    (json-config (shell-command-to-string (format  "eslint --print-config %s"
                               (shell-quote-argument
                            (buffer-file-name))))))
    (ignore-errors
      (setq js-indent-level
        (aref (gethash "indent" (gethash  "rules" (json-read-from-string json-config))) 1)))))

(add-hook 'js2-mode-hook #'js2-mode-use-eslint-indent)
(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook 'emmet-mode)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(setq company-tooltip-align-annotations t)

(add-hook 'before-save-hook 'tide-format-before-save)
(add-hook 'typescript-mode-hook #'setup-tide-mode)

(add-to-list 'auto-mode-alist '("\\.pp\\'" . pascal-mode))

; Ledger mode autocomplete
(add-hook 'ledger-mode-hook
          (lambda ()
                 (setq-local tab-always-indent 'complete)
                 (setq-local completion-cycle-threshold t)
                 (setq-local ledger-complete-in-steps t)))

; load environment variables
(exec-path-from-shell-initialize)

; Toggle fullscreen on Ctrl+return
(global-set-key (kbd "C-<return>") 'toggle-frame-fullscreen)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

; auto refresh in dired
(add-hook 'dired-mode-hook 'auto-revert-mode)

; spaces for tabs
(setq-default indent-tabs-mode nil)
