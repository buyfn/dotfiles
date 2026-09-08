;;; init.el --- Personal Emacs configuration -*- lexical-binding: t; -*-

;;;; Package Management
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;;;; Custom file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;;;; General Settings

;; UI chrome
(menu-bar-mode -1)
; (tool-bar-mode -1)
; (scroll-bar-mode -1)
(setq inhibit-startup-screen t)

;; Editing defaults
(setq-default indent-tabs-mode nil)
(setq completion-ignore-case t)

;; Backups in a dedicated directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; Line numbers in programming modes
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; Auto-revert buffers when files change on disk
(global-auto-revert-mode 1)

;; Mouse support in terminal (drag window borders to resize)
(xterm-mouse-mode 1)

;; Undo/redo window layouts with C-c left/right
(winner-mode 1)

;; Fullscreen toggle
(global-set-key (kbd "C-<return>") #'toggle-frame-fullscreen)

;; Tree-sitter grammar load path
(setq treesit-extra-load-path '("~/.emacs.d/tree-sitter"))

;;;; Terminal Emacs on macOS: sync kill ring with the system pasteboard
(unless (display-graphic-p)
  (when (executable-find "pbcopy")
    (setq interprogram-cut-function
          (lambda (text)
            (call-process-region text nil "pbcopy")))
    (setq interprogram-paste-function
          (lambda ()
            (let ((paste (shell-command-to-string "pbpaste")))
              (unless (string= paste (car kill-ring)) paste))))))

;;;; macOS: inherit shell environment
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :config
  (exec-path-from-shell-initialize))

;;;; Theme
(use-package alabaster-themes
  :config
  (load-theme 'alabaster-themes-dark t))

;;;; Paredit
(use-package paredit
  :ensure t
  :hook ((racket-mode . paredit-mode)
         (racket-repl-mode . paredit-mode)
         (emacs-lisp-mode . paredit-mode)))
(with-eval-after-load 'paredit
      ;; Paredit >= 25 binds RET to paredit-RET, which shadows REPL submit
      ;; bindings (e.g. racket-repl-submit). Unbind it.
      (define-key paredit-mode-map (kbd "RET") nil)
      (define-key paredit-mode-map (kbd "C-c C-]") #'paredit-forward-slurp-sexp)
      (define-key paredit-mode-map (kbd "C-c C-[") #'paredit-forward-barf-sexp))

;;;; Completion Framework (Vertico + Orderless + Marginalia + Consult)
(use-package vertico
  :init
  (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode))

;; In-buffer completion UI.  Keep it local to Racket buffers for now;
;; `racket-xp-mode' supplies the semantic completion candidates.
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  :hook (racket-mode . corfu-mode)
  :config
  ;; Avoid capturing RET when an automatic completion popup is visible.
  (keymap-unset corfu-map "RET"))

;; Use the terminal popup fallback only without native child-frame support.
(use-package corfu-terminal
  :unless (featurep 'tty-child-frames)
  :ensure t
  :after corfu
  :config
  (unless (display-graphic-p)
    (corfu-terminal-mode 1)))

;; project-find-file equivalent with live preview: the full project file
;; list appears immediately (synchronous, unlike the async consult-find,
;; which also lacks preview). Uses consult--read/consult--file-preview,
;; which are internal API — may need adjusting on major consult updates.
(defun my/project-find-file-preview ()
  "Find a file in the current project, previewing the selection."
  (interactive)
  (require 'consult)
  (let* ((project (project-current t))
         (root (project-root project))
         (default-directory root))
    (find-file
     (consult--read
      (mapcar (lambda (f) (file-relative-name f root))
              (project-files project))
      :prompt "Project file: "
      :sort t
      :require-match t
      :category 'file
      :state (consult--file-preview)
      :history 'file-name-history))))

(use-package consult
  :ensure t
  :bind (("C-x b" . consult-buffer)
         ("M-s l" . consult-line)
         :map project-prefix-map
         ("f" . my/project-find-file-preview)
         ;; project-find-regexp replacement with live preview (C-x p g)
         ("g" . consult-ripgrep)))

;;;; Tree-sitter auto-mode remapping
;; One-time auto-mode-alist setup instead of global-treesit-auto-mode:
;; the global mode re-probes grammar libraries in every new buffer,
;; which added ~0.6s to every file open (very noticeable in previews).
(use-package treesit-auto
  :config
  (setq treesit-auto-install 'prompt)
  (treesit-auto-add-to-auto-mode-alist))

;;;; LSP (eglot — built-in)
(use-package eglot
  :hook ((js-ts-mode        . eglot-ensure)
         (typescript-ts-mode . eglot-ensure)
         (tsx-ts-mode        . eglot-ensure))
  :config
  (setq eglot-autoshutdown t))

;;;; Version Control
(use-package magit
  :bind ("C-x g" . magit-status))

;;;; Text & Markdown: soft wrap at fill-column (70)
(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'")

(defun my/soft-wrap ()
  "Visually wrap lines at `fill-column' without inserting newlines."
  (unless (derived-mode-p 'ledger-mode)
    (visual-line-mode 1)
    (visual-fill-column-mode 1)))

(use-package visual-fill-column
  :ensure t
  :hook (text-mode . my/soft-wrap))

;;;; Language: Web (HTML / CSS)
(use-package web-mode
  :mode ("\\.html\\'" "\\.css\\'")
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-css-colorization t))

;;;; Language: JavaScript / TypeScript
;; js-ts-mode, typescript-ts-mode, tsx-ts-mode are built-in.
;; treesit-auto handles auto-mode-alist remapping.
;; eglot connects to typescript-language-server for both JS and TS.
(setq js-indent-level 2)
(setq typescript-ts-mode-indent-offset 2)

;;;; JavaScript REPL
(use-package js-comint
  :commands (js-comint-repl js-comint-send-last-sexp js-comint-send-region)
  :bind (:map js-ts-mode-map
         ("C-c C-z" . js-comint-repl)
         ("C-c C-e" . js-comint-send-last-sexp)
         ("C-c C-r" . js-comint-send-region)))

;;;; Language: Racket
(use-package racket-mode
  :mode "\\.rkt\\'"
  :hook (racket-mode . racket-xp-mode))

;;;; Language: SML
(use-package sml-mode
  :mode "\\.sml\\'"
  :custom
  (sml-indent-level 2))

;;;; Language: Ledger
(use-package ledger-mode
  :mode "\\.ledger\\'"
  :hook (ledger-mode . (lambda ()
                         (setq-local tab-always-indent 'complete)
                         (setq-local completion-cycle-threshold t)
                         (setq-local ledger-complete-in-steps t))))

;;;; Language: Pascal
(add-to-list 'auto-mode-alist '("\\.pp\\'" . pascal-mode))
(setq pascal-indent-level 2)

;;;; Minibuffer: insert today's date into any prompt with C-c d
(defun my/insert-date ()
  "Insert today's date at point, e.g. 2026-07-07."
  (interactive)
  (insert (format-time-string "%Y-%m-%d")))

(define-key minibuffer-local-map (kbd "C-c d") #'my/insert-date)
