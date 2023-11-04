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
   '("~/org-diss/paper3.org" "/mnt/data/green_lu/README.org" "/home/loki/org-diss/dissertation.org" "/home/loki/myorg.org"))
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
     ("" "amssymb" t nil)
     ("" "capt-of" nil nil)))
 '(package-selected-packages
   '(evil-nerd-commenter hl-todo rustic languagetool yaml-mode lsp-treemacs lsp-ui python-mode lsp-mode kind-icon corfu py-isort markdown-mode all-the-icons ledger-mode julia-mode python-black julia-repl smartparens adaptive-wrap haskell-mode darkroom langtool orderless evil-leader auto-highlight-symbol auto-dim-other-buffers buffer-move marginalia vertico fic-mode fci-mode elpy julia-snail vterm flycheck-julia evil-org transpose-frame mu4e-alert mu4e evil evil-collection rainbow-delimiters ido-vertical-mode dockerfile-mode openwith org-pdftools syntax-subword org-ref fill-column-indicator magit git-gutter neotree all-the-icons-ivy treemacs doom-themes doom-modeline dumb-jump ag counsel-projectile projectile powerline iedit expand-region undo-tree multiple-cursors yasnippet-snippets yasnippet flycheck ess org which-key use-package try tabbar org-bullets counsel color-theme-modern auto-org-md auto-complete ace-window))
 '(safe-local-variable-values
   '((eval setq org-latex-listings t)
     (org-ref-default-citation-link . "parencite")
     (languagetool-local-disabled-rules "TYPOGRAFISCHE_ANFUEHRUNGSZEICHEN" "F_ANSTATT_PH")
     (eval setq org-ref-default-citation-link "parencite")
     (eval setq org-latex-pdf-process
           (list "latexmk -shell-escape -bibtex -f -pdf %f"))
     (languagetool-local-disabled-rules "F_ANSTATT_PH")
     (org-latex-default-packages-alist)
     (languagetool-local-disabled-rules quote
                                        ("WHITESPACE_RULE"))
     (org-image-actual-width)
     (ledger-post-amount-alignment-column . 59)))
 '(send-mail-function 'smtpmail-send-it)
 '(warning-suppress-types '((:warning) (ox-pandoc) (ox-pandoc))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0)))))
(put 'narrow-to-region 'disabled nil)
