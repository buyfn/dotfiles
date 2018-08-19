
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

; run js2-mode for js files
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

; load environment variables
(exec-path-from-shell-initialize)

; Toggle fullscreen on Ctrl+return
(global-set-key (kbd "C-<return>") 'toggle-frame-fullscreen)
