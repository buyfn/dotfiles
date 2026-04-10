(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198"
    "#657b83"])
 '(backup-directory-alist '(("." . "~/.emacs.d/backups")))
 '(custom-safe-themes
   '("7fea145741b3ca719ae45e6533ad1f49b2a43bf199d9afaee5b6135fd9e6f9b8"
     default))
 '(inhibit-startup-screen t)
 '(initial-buffer-choice nil)
 '(js-indent-level 2)
 '(js2-mode-show-strict-warnings nil)
 '(ledger-reports
   '(("test" "ledger bal") ("bal" "%(binary) -f %(ledger-file) bal")
     ("reg" "%(binary) -f %(ledger-file) reg")
     ("payee" "%(binary) -f %(ledger-file) reg @%(payee)")
     ("account" "%(binary) -f %(ledger-file) reg %(account)")))
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(company company-ledger elixir-mode emmet-mode exec-path-from-shell
             flycheck js-comint js2-mode js2-refactor ledger-mode
             magit nim-mode racket-mode sml-mode solarized-theme tide
             treesit-auto typescript-mode xref-js2))
 '(pascal-indent-level 2)
 '(scroll-bar-mode nil)
 '(sml-indent-level 2)
 '(tool-bar-mode nil)
 '(typescript-indent-level 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#002b36" :foreground "#839496" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 140 :width normal :foundry "nil" :family "Monaspace Neon")))))
