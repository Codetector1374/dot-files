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
;; (setq doom-font (font-spec :family "Fira Code" :size 18))
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
(setq doom-theme 'doom-one-light)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; P4
(use-package! p4)
(use-package! ada-mode)

(use-package! clipetty
  :ensure t
  :hook (after-init . global-clipetty-mode))

(if (file-exists-p "~/.doom.d/config.local.el")
    (load "~/.doom.d/config.local.el"))

(setq scroll-margin 10)
(setq display-line-numbers-type 'relative)

;; .nvmk -> makefile
(add-to-list 'auto-mode-alist '("\\.nvmk\\'" . makefile-mode))

; better default indent style
;

(setq c-basic-offset 4
      tab-width 4
      c-default-style "gnu")

(setq projectile-dirconfig-comment-prefix "#")
(setq projectile-indexing-method 'alien)
(setq projectile-enable-caching t)

(after! lsp-mode
  (setq lsp-clients-clangd-args '("-j=8" "--header-insertion=never" "--query-driver=**")))

(defun my-c-paren-hooks ()
  (sp-local-pair 'c-mode "/*!" nil :actions :rem)
  (sp-local-pair 'c-mode "/*!" "*/"
                 :post-handlers '((" ||\n [i]" "RET") ("|| " "SPC")))

  (defun priv-cmode-sp-comment-post-hook (id action ctx)
    (if (save-excursion
          (back-to-indentation)
          (if (eq (char-after) ?*) t nil))
        (progn
          (save-excursion
            (insert "\n ")
            (indent-according-to-mode)))
      (progn
        (save-excursion
          (insert " ")))
      ))
  (sp-local-pair 'c-mode "/*" nil :actions :rem)
  (sp-local-pair 'c-mode "/*" "*/"
                 :when '(("SPC" "RET" "<evil-ret>"))
                 :post-handlers '(priv-cmode-sp-comment-post-hook))
  )

(map! :map global-map
      :i "<tab>" 'tab-to-tab-stop)
(map! :map global-map
      :i "TAB" 'tab-to-tab-stop)

(defun my-c-hook ()
  (progn
    (setq lsp-enable-indentation nil)

    ;; NV-RM C-Style Config
    (defun nv-c-offset-statement-cont (ctx)
      (if (char-equal
           (char-after (save-excursion (back-to-indentation) (point)))
           ?{
           )
          0
        '+
        )
      )
    (c-add-style "nvidia-rm" '(
                               (c-doc-comment-style (c-mode . doxygen))
                               (c-basic-offset . 4)
                               (c-hanging-braces-alist)
                               (c-offsets-alist
                                (func-decl-cont . 0)
                                (arglist-intro . +)
                                (arglist-close . 0)
                                (arglist-cont-nonempty . +)
                                (substatement-open . 0)
                                (statement-cont . nv-c-offset-statement-cont)
                                (label . 0))
                               ))

    (display-fill-column-indicator-mode 1)

    ;; Apply NV Hook if we see ~/.nvidia
    (setq lsp-enable-indentation t)
    (if (file-exists-p "~/.nvidia")
        (progn
          (setq lsp-enable-indentation nil)
          (setq c-default-style "nvidia-rm")
          (c-set-style "nvidia-rm")
          (message "NVIDIA Profile Loaded")
          (my-c-paren-hooks)
          )
      )
    )
  )
(add-hook 'c-mode-hook 'my-c-hook)

(add-hook 'perl-mode-hook (lambda () (smartparens-mode 0)))

(with-eval-after-load 'evil (defalias #'forward-evil-word #'forward-evil-symbol))

(map! :leader :desc "Toggle Shell" "o t" 'shell)
(map! :leader :desc "Toggle Treemacs" "o ;" 'treemacs)
(map! :leader
      (:prefix ("l" . "lsp")
       :desc "restart-lsp" "r" #'lsp-restart-workspace
       :desc "format-buffer" "f" #'lsp-format-buffer))

(map! :leader
      (:prefix ("v" . "vcs")
       :desc "p4-add" "a" #'p4-add
       :desc "p4-reopen" "r" #'p4-reopen
       :desc "p4-edit" "e" #'p4-edit
       :desc "p4-diff" "d" #'p4-ediff))

(map! :desc "flycheck prev error" :n "[ e" 'flycheck-previous-error)
(map! :desc "flycheck next error" :n "] e" 'flycheck-next-error)

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
