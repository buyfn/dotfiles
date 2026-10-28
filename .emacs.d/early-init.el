;;; early-init.el --- Early startup settings -*- lexical-binding: t; -*-

;; Bundled libgccjit can derive an invalid macOS deployment target from
;; the Darwin kernel version.  Use the actual macOS version before package
;; activation and native compilation, preserving any explicit target.
(when (and (eq system-type 'darwin)
           (not (getenv "MACOSX_DEPLOYMENT_TARGET")))
  (setenv "MACOSX_DEPLOYMENT_TARGET"
          (car (process-lines "/usr/bin/sw_vers" "-productVersion"))))

;;; early-init.el ends here
