;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Yaotian Feng"
      user-mail-address "codetector@codetector.org")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Fira Code" :size 14))
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


(setq scroll-margin 10)

; better default indent style

(setq c-basic-offset 4
      tab-width 4
      indent-tabs-mode t
      c-default-style "user")

(defun nv-c-style-hook ()
  (c-set-offset 'func-decl-cont 0)
  (c-set-offset 'arglist-close 0)
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'label 0)
  )
(if (file-exists-p "~/.nvidia")
    (progn
      (message "NVIDIA Profile Loaded")
      (add-hook 'c-mode-hook 'nv-c-style-hook)
      )
)

(defun generic-c-hook ()
  (define-key c-mode-base-map (kbd "<tab>") 'tab-to-tab-stop)
  (define-key c-mode-base-map [tab] 'tab-to-tab-stop)
)
(add-hook 'c-mode-hook 'generic-c-hook)


(defun p4-select-changelist ()
  "hello"
  )


(defun my-test-fun (filepath)
  "Mark file as edit in p4"
  (interactive
   (list buffer-file-name)
   )
  (let ((p4client (getenv "P4CLIENT")))
    (message "hello %s : client => %s" filepath (p4-select-changelist))
    )
  )

(map! :leader
      (:prefix ("v" . "Version Control")
       (:prefix ("p" . "Perforce")
        :desc "p4 edit"
        "e" #'my-test-fun)))

(setq +format-with-lsp nil)

                                        ; https://github.com/syl20bnr/spacemacs/issues/9740
(with-eval-after-load 'evil (defalias #'forward-evil-word #'forward-evil-symbol))

;; (delete "" (split-string (shell-command-to-string (format "p4 changes --me -s pending -c %s" (getenv "P4CLIENT"))) "\n"))

;; (completing-read
;;  "Completion Title: "
;;  '(("foobar" 1) ("bar" 2))
;;  nil t nil)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
