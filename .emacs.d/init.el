;; add package repositories
(require 'package)
(setq package-enable-at-startup nil)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; load further configuration from org file
(org-babel-load-file (expand-file-name "~/.emacs.d/configuration.org"))



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(doc-view-continuous nil)
 '(helm-minibuffer-history-key "M-p")
 '(org-agenda-files
   '("/mnt/data/green_lu/README.org" "~/org-diss/paper3.org" "~/org-diss/dissertation.org" "~/myorg.org"))
 '(org-latex-default-packages-alist
   '(("AUTO" "inputenc" t
      ("pdflatex"))
     ("T1" "fontenc" t
      ("pdflatex"))
     ("" "graphicx" t nil)
     ("" "grffile" t nil)
     ("" "longtable" nil nil)
     ("" "wrapfig" nil nil)
     ("" "rotating" nil nil)
     ("normalem" "ulem" t nil)
     ("" "amsmath" t nil)
     ("" "textcomp" t nil)
     ("" "amssymb" t nil)
     ("" "capt-of" nil nil)
     ("colorlinks=true, allcolors=MidnightBlue, final=true" "hyperref" nil nil)
     ("dvipsnames, usenames" "xcolor" nil nil)))
 '(package-selected-packages
   '(julia-repl smartparens adaptive-wrap haskell-mode darkroom langtool orderless evil-leader auto-highlight-symbol auto-dim-other-buffers buffer-move marginalia vertico fic-mode fci-mode elpy julia-snail vterm flycheck-julia evil-org transpose-frame mu4e-alert mu4e evil evil-collection rainbow-delimiters ido-vertical-mode dockerfile-mode openwith org-pdftools syntax-subword org-ref fill-column-indicator company-distel company-jedi magit git-gutter neotree all-the-icons-ivy treemacs doom-themes doom-modeline dumb-jump ag counsel-projectile projectile powerline iedit expand-region undo-tree multiple-cursors yasnippet-snippets yasnippet flycheck ess org which-key use-package try tabbar org-bullets counsel color-theme-modern auto-org-md auto-complete ace-window))
 '(send-mail-function 'smtpmail-send-it))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0))))
 '(company-scrollbar-bg ((t (:background "#3a943f99449e"))))
 '(company-scrollbar-fg ((t (:background "#2eca32cc36cf"))))
 '(company-tooltip ((t (:inherit default :background "#27b72b1e2e86"))))
 '(company-tooltip-common ((t (:inherit font-lock-constant-face))))
 '(company-tooltip-selection ((t (:inherit font-lock-function-name-face)))))
(put 'narrow-to-region 'disabled nil)
