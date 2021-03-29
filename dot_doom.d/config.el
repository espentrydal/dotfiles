;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Espen Trydal"
      user-mail-address "espen@trydal.io")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(use-package! org-roam
  :init
  (map! :leader
        :prefix "n"
        :desc "org-roam" "l" #'org-roam-buffer
        :desc "org-roam-node-insert" "i" #'org-roam-node-insert
        :desc "org-roam-node-find" "f" #'org-roam-node-find
        :desc "org-roam-ref-find" "r" #'org-roam-ref-find
        :desc "org-roam-show-graph" "g" #'org-roam-show-graph
        :desc "org-roam-capture" "c" #'org-roam-capture
        ;; :desc "org-roam-dailies-capture-today" "j" #'org-roam-dailies-capture-today)

  (setq org-roam-directory (file-truename "~/.org/roam/")
        org-roam-db-gc-threshold most-positive-fixnum
        org-id-link-to-org-use-id t)
  :config
  (org-roam-setup)
  (require 'org-roam-backlinks)
  (require 'org-roam-reflinks)
  (require 'org-roam-unlinked-references)
  (setq org-roam-mode-sections
        (list #'org-roam-backlinks-insert-section
              #'org-roam-reflinks-insert-section
              #'org-roam-unlinked-references-insert-section))
  (setq org-roam-capture-templates
        '(("d" "default" plain (function org-roam-capture--get-point)
           "%?"
           :file-name "${slug}"
           :head "#+title: ${title}\n"
           :immediate-finish t
           :unnarrowed t)
          ("p" "private" plain (function org-roam-capture--get-point)
           "%?"
           :file-name "private/${slug}"
           :head "#+title: ${title}\n"
           :immediate-finish t
           :unnarrowed t)))
  (setq org-roam-capture-ref-templates
        '(("r" "ref" plain (function org-roam-capture--get-point)
           "%?"
           :file-name "${slug}"
           :head "#+roam_key: ${ref}
#+roam_tags: website
#+title: ${title}
- source :: ${ref}"
           :unnarrowed t)))
  (add-to-list 'org-capture-templates `("c" "org-protocol-capture" entry (file+olp ,(expand-file-name "reading_and_writing_inbox.org" org-roam-directory) "The List")
                                         "* TO-READ [[%:link][%:description]] %^g"
                                         :immediate-finish t))
  (add-to-list 'org-agenda-custom-commands `("r" "Reading"
                                             ((todo "WRITING"
                                                    ((org-agenda-overriding-header "Writing")
                                                     (org-agenda-files '(,(expand-file-name "reading_and_writing_inbox.org" org-roam-directory)))))
                                              (todo "READING"
                                                    ((org-agenda-overriding-header "Reading")
                                                     (org-agenda-files '(,(expand-file-name "reading_and_writing_inbox.org" org-roam-directory)))))
                                              (todo "TO-READ"
                                                    ((org-agenda-overriding-header "To Read")
                                                     (org-agenda-files '(,(expand-file-name "reading_and_writing_inbox.org" org-roam-directory))))))))
  ;; (setq org-roam-dailies-directory "daily/")
  ;; (setq org-roam-dailies-capture-templates
  ;;     '(("d" "default" entry
  ;;        #'org-roam-capture--get-point
  ;;        "* %?"
  ;;        :file-name "daily/%<%Y-%m-%d>"
  ;;        :head "#+title: %<%Y-%m-%d>\n\n")))
  (set-company-backend! 'org-mode '(company-capf)))

  (after! org-ref
    (setq org-ref-default-bibliography `,(list (concat org-directory "braindump/org/biblio.bib"))))

(use-package! org-roam-bibtex
  :after org-roam
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :config
  (require 'org-ref)) ; optional: if Org Ref is not loaded anywhere else, load it here
