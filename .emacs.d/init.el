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
 '(org-agenda-files (quote ("~/myorg.org")))
 '(package-selected-packages
   (quote
    (magit git-gutter neotree all-the-icons-ivy treemacs doom-themes doom-modeline dumb-jump ag counsel-projectile projectile powerline iedit expand-region undo-tree multiple-cursors yasnippet-snippets yasnippet flycheck ess org which-key use-package try tabbar org-bullets counsel color-theme-modern auto-org-md auto-complete ace-window))))
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