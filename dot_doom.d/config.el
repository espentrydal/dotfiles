;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

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


(setq org-directory "~/org/"
      org-ellipsis " ▼ ")
(map! :leader
      :prefix "n"
      "c" #'org-capture)
(map! :map org-mode-map
      "M-n" #'outline-next-visible-heading
      "M-p" #'outline-previous-visible-heading)
(setq org-src-window-setup 'current-window
      org-return-follows-link t
      org-babel-load-languages '((emacs-lisp . t)
                                 (python . t)
                                 (dot . t)
                                 (R . t))
      org-confirm-babel-evaluate nil
      org-use-speed-commands t
      org-catch-invisible-edits 'show
      org-preview-latex-image-directory "/tmp/ltximg/"
      org-structure-template-alist '(("a" . "export ascii")
                                     ("c" . "center")
                                     ("C" . "comment")
                                     ("e" . "example")
                                     ("E" . "export")
                                     ("h" . "export html")
                                     ("l" . "export latex")
                                     ("q" . "quote")
                                     ("s" . "src")
                                     ("v" . "verse")
                                     ("el" . "src emacs-lisp")
                                     ("d" . "definition")
                                     ("t" . "theorem")))
(use-package! org-roam
  :after org
  :commands
  (org-roam-buffer
   org-roam-setup
   org-roam-capture
   org-roam-node-find)
  :init
  (map! :leader
        :prefix "n"
        :desc "org-roam" "l" #'org-roam-buffer-toggle
        :desc "org-roam-node-insert" "i" #'org-roam-node-insert
        :desc "org-roam-node-find" "f" #'org-roam-node-find
        :desc "org-roam-ref-find" "r" #'org-roam-ref-find
        :desc "org-roam-show-graph" "g" #'org-roam-show-graph
        :desc "org-roam-capture" "c" #'org-roam-capture
        :desc "org-roam-dailies-capture-today" "j" #'org-roam-dailies-capture-today)
  (setq org-roam-directory (file-truename "~/org/roam/")
        org-roam-db-gc-threshold most-positive-fixnum
        org-id-link-to-org-use-id t)
  (add-to-list 'display-buffer-alist
               '(("\\*org-roam\\*"
                  (display-buffer-in-direction)
                  (direction . right)
                  (window-width . 0.33)
                  (window-height . fit-window-to-buffer))))
 ;; :config
 ;;  (setq org-roam-mode-sections
 ;;        (list #'org-roam-backlinks-insert-section
 ;;              #'org-roam-reflinks-insert-section
 ;;              #'org-roam-unlinked-references-insert-section
 ;;              ))
  (org-roam-setup))

;; (use-package! org-roam-bibtex
;;   :after org-roam
;;   :hook (org-roam-mode . org-roam-bibtex-mode)
;;   :config
;;   (require 'org-ref))


(use-package! ctrlf
  :hook
  (after-init . ctrlf-mode))

(use-package! smartparens
  :init
  (map! :map smartparens-mode-map
        "C-M-f" #'sp-forward-sexp
        "C-M-b" #'sp-backward-sexp
        "C-M-u" #'sp-backward-up-sexp
        "C-M-d" #'sp-down-sexp
        "C-M-p" #'sp-backward-down-sexp
        "C-M-n" #'sp-up-sexp
        "C-M-s" #'sp-splice-sexp
        "C-)" #'sp-forward-slurp-sexp
        "C-}" #'sp-forward-barf-sexp
        "C-(" #'sp-backward-slurp-sexp
        "C-M-)" #'sp-backward-slurp-sexp
        "C-M-)" #'sp-backward-barf-sexp))

(setq rmh-elfeed-org-files "~/org/elfeed.org")

(setq +notmuch-sync-backend 'mbsync)
(after! notmuch
  (set-popup-rule! "^\\*notmuch-hello" :ignore t)
  (setq notmuch-saved-searches '((:name "Unread"
                                  :query "tag:inbox and tag:unread"
                                  :count-query "tag:inbox and tag:unread"
                                  :sort-order newest-first
                                  :key "u")
                                 (:name "Inbox"
                                  :query "tag:inbox"
                                  :count-query "tag:inbox"
                                  :sort-order newest-first
                                  :key "i")
                                 (:name "All mail"
                                  :query "*"
                                  :sort-order newest-first
                                  :key "a")
                                 (:name "Sent"
                                  :query "tag:sent or tag:replied"
                                  :count-query "tag:sent or tag:replied"
                                  :sort-order newest-first)
                                 (:name "Trash"
                                  :query "tag:deleted"
                                  :count-query "tag:deleted"
                                  :sort-order newest-first)))


;; ; stores postponed messages to the specified directory
;; (setq message-directory "MailLocation/Drafts") ;

;; ;set sent mail directory
;; (setq notmuch-fcc-dirs "MailLocation/Sent")

;Settings for main screen
(setq notmuch-hello-hide-tags (quote ("killed")))

;; ;Message composition and sending settings

;; ;Setup User-Agent header
;; (setq mail-user-agent 'message-user-agent)

;; (setq message-kill-buffer-on-exit t) ; kill buffer after sending mail)
;; (setq mail-specify-envelope-from t) ; Settings to work with msmtp

;; (setq send-mail-function (quote sendmail-send-it))
;; (setq sendmail-program "~/.local/bin/msmtp-enqueue.sh"
;;   mail-specify-envelope-from t
;; ;; needed for debians message.el cf. README.Debian.gz
;;  message-sendmail-f-is-evil nil
;;   mail-envelope-from 'header
;;   message-sendmail-envelope-from 'header)

;Reading mail settings:

(define-key notmuch-show-mode-map "y"
    (lambda ()
    "mark message as archived (tag)"
    (interactive)
(notmuch-show-tag (list "+archive" "-inbox"))))

(define-key notmuch-search-mode-map "y"
(lambda ()
    "mark message as archived"
    (interactive)
    (notmuch-search-tag (list "-inbox" "+archive"))
    (next-line) ))

(define-key notmuch-show-mode-map "d"
    (lambda ()
    "mark message as deleted"
    (interactive)
(notmuch-show-tag (list "+deleted" "-inbox"))))

(define-key notmuch-search-mode-map "d"
(lambda ()
    "mark message as deleted"
    (interactive)
    (notmuch-search-tag (list "-inbox" "+deleted"))
    (next-line) ))

(define-key notmuch-show-mode-map "S"
    (lambda ()
    "mark message as spam"
    (interactive)
(notmuch-show-tag (list "+spam" "-inbox"))))

(define-key notmuch-search-mode-map "S"
(lambda ()
    "mark message as spam"
    (interactive)
    (notmuch-search-tag (list "-inbox" "+spam"))
    (next-line) ))

(defun my-notmuch-show-unsubscribe ()
  "When in a notmuch show mail, try to find an unsubscribe link and click it..

   This will be the link nearest the end of the message which either contains or follows the word unsubscribe."
  (interactive)
  (notmuch-show-move-to-message-bottom)
  (when (search-backward "unsubscribe" (notmuch-show-message-top))
    (if (ffap-url-at-point)
        (goto-char (car ffap-string-at-point-region)))

    (ffap-next-url))))

;; (defun set-exec-path-from-shell-PATH ()
;;   "Set up Emacs' `exec-path' and PATH environment variable to match
;; that used by the user's shell.

;; This is particularly useful under Mac OS X and macOS, where GUI
;; apps are not started from a shell."
;;   (interactive)
;;   (let ((path-from-shell (replace-regexp-in-string
;;                           "[ \t\n]*$" "" (shell-command-to-string
;;                                           "$SHELL --login -c 'echo $PATH'"
;;                                           ))))
;;     (setenv "PATH" path-from-shell)
;;     (setq exec-path (split-string path-from-shell path-separator))))

;; (set-exec-path-from-shell-PATH)
