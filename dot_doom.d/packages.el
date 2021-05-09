;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)

;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)

(package! org-roam
  :recipe (:host github :repo "org-roam/org-roam" :branch "v2"))

(package! ctrlf)

;; (package! org-roam-bibtex
;;   :recipe (:host github :repo "org-roam/org-roam-bibtex" : branch "org-roam-v2"))
;; (unpin! bibtex-completion helm-bibtex ivy-bibtex)

(unpin! jupyter)
