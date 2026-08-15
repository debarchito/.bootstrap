;;; -*- lexical-binding: t; -*-
;;; (Adapted) dankcolors-theme.el --- Enhanced theme using Matugen SCSS variables with dank16 colors

;; Copyright (C) 2025

;; Author: Generated (Enhanced)
;; Version: 1.3
;; Package-Requires: ((emacs "24.1"))
;; Keywords: faces

;;; Commentary:

;; An enhanced theme using Matugen SCSS variables integrated with dank16 colors:
;; - Rich color palette from dank16 for vibrant syntax highlighting
;; - Improved contrast and readability
;; - Better source block distinction with refined backgrounds
;; - Enhanced org-mode styling with hidden asterisks
;; - Superior visual hierarchy and modern aesthetics

;;; Code:

(deftheme dankcolors "Enhanced theme using Matugen variables with dank16 color integration.")

<* if {{ is_dark_mode }} *>
(let* ((bg "{{colors.surface_container_low.dark.hex}}")
       (fg "{{colors.on_surface.dark.hex}}")
       (fg-inactive "{{colors.on_surface_variant.dark.hex}}")
       (cursor-bg "{{colors.primary.dark.hex}}")
       (cursor-fg "{{colors.background.dark.hex}}")
       (linenr "{{colors.on_surface_variant.dark.hex}}")
       (linenr-selected "{{colors.primary.dark.hex}}")
       (status-bg "{{colors.surface_container.dark.hex}}")
       (status-fg "{{colors.on_surface.dark.hex}}")
       (status-inactive-bg "{{colors.surface_container_low.dark.hex}}")
       (status-inactive-fg "{{colors.on_surface_variant.dark.hex}}")
       (selection-bg "{{colors.secondary_container.dark.hex}}")
       (selection-fg "{{colors.on_secondary_container.dark.hex}}")
       (primary "{{colors.primary.dark.hex}}")
       (primary-fixed "{{colors.primary_fixed.dark.hex}}")
       (secondary "{{colors.secondary.dark.hex}}")
       (secondary-fixed "{{colors.secondary_fixed.dark.hex}}")
       (tertiary "{{colors.tertiary.dark.hex}}")
       (tertiary-fixed "{{colors.tertiary_fixed.dark.hex}}")
       (tertiary-fixed-dim "{{colors.tertiary_fixed_dim.dark.hex}}")
       (error "{{colors.error.dark.hex}}")
       (outline-variant "{{colors.outline_variant.dark.hex}}")
       (surface-container-high "{{colors.surface_container_high.dark.hex}}")
       (surface-container-highest "{{colors.surface_container_highest.dark.hex}}")
       (surface-container-low "{{colors.surface_container_low.dark.hex}}")
       (surface-container "{{colors.surface_container.dark.hex}}"))
<* else *>
(let* ((bg "{{colors.surface_container_low.light.hex}}")
       (fg "{{colors.on_surface.light.hex}}")
       (fg-inactive "{{colors.on_surface_variant.light.hex}}")
       (cursor-bg "{{colors.primary.light.hex}}")
       (cursor-fg "{{colors.background.light.hex}}")
       (linenr "{{colors.on_surface_variant.light.hex}}")
       (linenr-selected "{{colors.primary.light.hex}}")
       (status-bg "{{colors.surface_container.light.hex}}")
       (status-fg "{{colors.on_surface.light.hex}}")
       (status-inactive-bg "{{colors.surface_container_low.light.hex}}")
       (status-inactive-fg "{{colors.on_surface_variant.light.hex}}")
       (selection-bg "{{colors.secondary_container.light.hex}}")
       (selection-fg "{{colors.on_secondary_container.light.hex}}")
       (primary "{{colors.primary.light.hex}}")
       (primary-fixed "{{colors.primary.light.hex}}")
       (secondary "{{colors.secondary.light.hex}}")
       (secondary-fixed "{{colors.on_surface_variant.light.hex}}")
       (tertiary "{{colors.tertiary.light.hex}}")
       (tertiary-fixed "{{colors.tertiary_fixed.light.hex}}")
       (tertiary-fixed-dim "{{colors.tertiary_fixed_dim.light.hex}}")
       (error "{{colors.error.light.hex}}")
       (outline-variant "{{colors.outline_variant.light.hex}}")
       (surface-container-high "{{colors.surface_container_high.light.hex}}")
       (surface-container-highest "{{colors.surface_container_highest.light.hex}}")
       (surface-container-low "{{colors.surface_container_low.light.hex}}")
       (surface-container "{{colors.surface_container.light.hex}}"))
<* endif *>

  (custom-theme-set-faces
   'dankcolors
   ;; Basic faces
   `(default ((t (:background ,bg :foreground ,fg))))
   `(cursor ((t (:background ,cursor-bg :foreground ,cursor-fg))))
   `(highlight ((t (:background ,surface-container-highest))))
   `(region ((t (:background ,selection-bg :extend t))))
   `(secondary-selection ((t (:background ,surface-container-high :extend t))))
   `(isearch ((t (:background ,primary :foreground ,bg :weight bold))))
   `(lazy-highlight ((t (:background ,surface-container-highest :foreground ,primary))))
   `(vertical-border ((t (:foreground ,outline-variant))))
   `(border ((t (:background ,outline-variant :foreground ,outline-variant))))
   `(fringe ((t (:background ,bg :foreground ,linenr))))
   `(shadow ((t (:foreground ,fg-inactive))))
   `(link ((t (:foreground ,primary :underline t))))
   `(link-visited ((t (:foreground ,tertiary :underline t))))
   `(success ((t (:foreground ,tertiary))))
   `(warning ((t (:foreground ,tertiary-fixed-dim))))
   `(error ((t (:foreground ,error))))
   `(match ((t (:background ,surface-container-highest :foreground ,primary :weight bold))))

   ;; Font-lock - aligned with Helix uniformity for syntax highlighting
   `(font-lock-builtin-face ((t (:foreground ,primary))))
   `(font-lock-comment-face ((t (:foreground ,fg-inactive :slant italic))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,fg-inactive :slant italic))))
   `(font-lock-constant-face ((t (:foreground ,tertiary))))
   `(font-lock-doc-face ((t (:foreground ,fg-inactive :slant italic))))
   `(font-lock-function-name-face ((t (:foreground ,primary))))
   `(font-lock-keyword-face ((t (:foreground ,secondary))))
   `(font-lock-string-face ((t (:foreground ,tertiary))))
   `(font-lock-type-face ((t (:foreground ,primary-fixed))))
   `(font-lock-variable-name-face ((t (:foreground ,fg))))
   `(font-lock-warning-face ((t (:foreground ,tertiary-fixed-dim :underline (:style wave :color ,tertiary-fixed-dim)))))
   `(font-lock-preprocessor-face ((t (:foreground ,secondary))))
   `(font-lock-negation-char-face ((t (:foreground ,secondary))))

   ;; Show paren
   `(show-paren-match ((t (:background ,surface-container-high :foreground ,primary :weight bold))))
   `(show-paren-mismatch ((t (:background ,error :foreground ,bg :weight bold))))

   ;; Mode line - improved status bar styling mapped to helix
   `(mode-line ((t (:background ,status-bg :foreground ,status-fg :box nil))))
   `(mode-line-inactive ((t (:background ,status-inactive-bg :foreground ,status-inactive-fg :box nil))))
   `(mode-line-buffer-id ((t (:foreground ,primary :weight bold))))
   `(mode-line-emphasis ((t (:foreground ,primary :weight bold))))
   `(mode-line-highlight ((t (:foreground ,primary :box nil))))

   ;; Improved Source blocks - seamless integration
   `(org-block ((t (:background ,surface-container-low :extend t :inherit fixed-pitch))))
   `(org-block-begin-line ((t (:background ,surface-container-low :foreground ,fg-inactive :extend t :slant italic :inherit fixed-pitch))))
   `(org-block-end-line ((t (:background ,surface-container-low :foreground ,fg-inactive :extend t :slant italic :inherit fixed-pitch))))
   `(org-code ((t (:background ,surface-container-low :foreground ,primary :inherit fixed-pitch))))
   `(org-verbatim ((t (:background ,surface-container-low :foreground ,primary :inherit fixed-pitch))))
   `(org-meta-line ((t (:foreground ,fg-inactive :slant italic))))

   ;; Org mode with enhanced colors and hidden asterisks
   `(org-level-1 ((t (:foreground ,primary :weight bold :height 1.2))))
   `(org-level-2 ((t (:foreground ,secondary :weight bold :height 1.1))))
   `(org-level-3 ((t (:foreground ,tertiary :weight bold))))
   `(org-level-4 ((t (:foreground ,primary :weight bold))))
   `(org-level-5 ((t (:foreground ,secondary :weight bold))))
   `(org-level-6 ((t (:foreground ,tertiary :weight bold))))
   `(org-level-7 ((t (:foreground ,primary :weight bold))))
   `(org-level-8 ((t (:foreground ,secondary :weight bold))))
   `(org-document-title ((t (:foreground ,primary :weight bold :height 1.3))))
   `(org-document-info ((t (:foreground ,secondary))))
   `(org-todo ((t (:foreground ,error :weight bold))))
   `(org-done ((t (:foreground ,tertiary :weight bold))))
   `(org-headline-done ((t (:foreground ,fg-inactive))))
   `(org-hide ((t (:foreground ,bg))))
   `(org-ellipsis ((t (:foreground ,secondary :underline nil))))
   `(org-table ((t (:foreground ,secondary :inherit fixed-pitch))))
   `(org-formula ((t (:foreground ,primary :inherit fixed-pitch))))
   `(org-checkbox ((t (:foreground ,secondary :weight bold :inherit fixed-pitch))))
   `(org-date ((t (:foreground ,tertiary :underline t))))
   `(org-special-keyword ((t (:foreground ,fg-inactive :slant italic))))
   `(org-tag ((t (:foreground ,secondary :weight normal))))

   ;; Magit with enhanced diff colors
   `(magit-section-highlight ((t (:background ,surface-container))))
   `(magit-diff-hunk-heading ((t (:background ,surface-container :foreground ,fg-inactive))))
   `(magit-diff-hunk-heading-highlight ((t (:background ,surface-container-high :foreground ,fg))))
   `(magit-diff-context ((t (:foreground ,fg-inactive))))
   `(magit-diff-context-highlight ((t (:background ,surface-container-low :foreground ,fg))))
   `(magit-diff-added ((t (:foreground ,tertiary))))
   `(magit-diff-added-highlight ((t (:background ,surface-container :foreground ,tertiary :weight bold))))
   `(magit-diff-removed ((t (:foreground ,error))))
   `(magit-diff-removed-highlight ((t (:background ,surface-container :foreground ,error :weight bold))))
   `(magit-hash ((t (:foreground ,fg-inactive))))
   `(magit-branch-local ((t (:foreground ,secondary :weight bold))))
   `(magit-branch-remote ((t (:foreground ,primary :weight bold))))

   ;; Company
   `(company-tooltip ((t (:background ,surface-container-high :foreground ,fg))))
   `(company-tooltip-selection ((t (:background ,selection-bg :foreground ,selection-fg))))
   `(company-tooltip-common ((t (:foreground ,primary))))
   `(company-tooltip-common-selection ((t (:foreground ,primary :weight bold))))
   `(company-tooltip-annotation ((t (:foreground ,secondary))))
   `(company-scrollbar-fg ((t (:background ,primary))))
   `(company-scrollbar-bg ((t (:background ,surface-container))))
   `(company-preview ((t (:foreground ,fg-inactive :slant italic))))
   `(company-preview-common ((t (:foreground ,primary :slant italic))))

   ;; Ido
   `(ido-first-match ((t (:foreground ,primary :weight bold))))
   `(ido-only-match ((t (:foreground ,tertiary :weight bold))))
   `(ido-subdir ((t (:foreground ,secondary))))
   `(ido-indicator ((t (:foreground ,error))))
   `(ido-virtual ((t (:foreground ,fg-inactive))))

   ;; Helm
   `(helm-selection ((t (:background ,selection-bg))))
   `(helm-match ((t (:foreground ,primary :weight bold))))
   `(helm-source-header ((t (:background ,surface-container-high :foreground ,primary :weight bold :height 1.1))))
   `(helm-candidate-number ((t (:foreground ,secondary :weight bold))))
   `(helm-ff-directory ((t (:foreground ,primary :weight bold))))
   `(helm-ff-file ((t (:foreground ,fg))))
   `(helm-ff-executable ((t (:foreground ,tertiary))))

   ;; corfu
   `(corfu-default ((t (:background ,surface-container-high :foreground ,fg))))
   `(corfu-current ((t (:background ,selection-bg))))

   ;; Which-key
   `(which-key-key-face ((t (:foreground ,primary :weight bold))))
   `(which-key-separator-face ((t (:foreground ,outline-variant))))
   `(which-key-command-description-face ((t (:foreground ,fg))))
   `(which-key-group-description-face ((t (:foreground ,secondary))))
   `(which-key-special-key-face ((t (:foreground ,primary :weight bold))))

   ;; Line numbers
   `(line-number ((t (:foreground ,linenr :inherit fixed-pitch))))
   `(line-number-current-line ((t (:foreground ,linenr-selected :weight bold :inherit fixed-pitch))))

   ;; Parenthesis matching
   `(sp-show-pair-match-face ((t (:background ,surface-container-high :foreground ,primary))))
   `(sp-show-pair-mismatch-face ((t (:background ,error :foreground ,bg))))

   ;; Rainbow delimiters - restrained for semantic uniformity
   `(rainbow-delimiters-depth-1-face ((t (:foreground ,secondary-fixed))))
   `(rainbow-delimiters-depth-2-face ((t (:foreground ,secondary))))
   `(rainbow-delimiters-depth-3-face ((t (:foreground ,tertiary))))
   `(rainbow-delimiters-depth-4-face ((t (:foreground ,primary))))
   `(rainbow-delimiters-depth-5-face ((t (:foreground ,secondary-fixed))))
   `(rainbow-delimiters-depth-6-face ((t (:foreground ,secondary))))
   `(rainbow-delimiters-depth-7-face ((t (:foreground ,tertiary))))
   `(rainbow-delimiters-depth-8-face ((t (:foreground ,primary))))
   `(rainbow-delimiters-depth-9-face ((t (:foreground ,secondary-fixed))))
   `(rainbow-delimiters-mismatched-face ((t (:foreground ,error :weight bold))))
   `(rainbow-delimiters-unmatched-face ((t (:foreground ,error :weight bold))))

   ;; Dired
   `(dired-directory ((t (:foreground ,primary :weight bold))))
   `(dired-ignored ((t (:foreground ,fg-inactive))))
   `(dired-flagged ((t (:foreground ,error))))
   `(dired-marked ((t (:foreground ,secondary :weight bold))))
   `(dired-symlink ((t (:foreground ,tertiary :slant italic))))
   `(dired-header ((t (:foreground ,primary :weight bold :height 1.1))))

   ;; EShell
   `(eshell-prompt ((t (:foreground ,primary :weight bold))))
   `(eshell-ls-directory ((t (:foreground ,primary :weight bold))))
   `(eshell-ls-symlink ((t (:foreground ,tertiary :slant italic))))
   `(eshell-ls-executable ((t (:foreground ,tertiary))))
   `(eshell-ls-archive ((t (:foreground ,secondary))))
   `(eshell-ls-backup ((t (:foreground ,fg-inactive))))
   `(eshell-ls-clutter ((t (:foreground ,error))))
   `(eshell-ls-missing ((t (:foreground ,error))))
   `(eshell-ls-product ((t (:foreground ,fg-inactive))))
   `(eshell-ls-readonly ((t (:foreground ,fg-inactive))))
   `(eshell-ls-special ((t (:foreground ,secondary))))
   `(eshell-ls-unreadable ((t (:foreground ,fg-inactive))))

   ;; Improved markdown mode
   `(markdown-header-face ((t (:foreground ,primary :weight bold))))
   `(markdown-header-face-1 ((t (:foreground ,primary :weight bold :height 1.2))))
   `(markdown-header-face-2 ((t (:foreground ,secondary :weight bold :height 1.1))))
   `(markdown-header-face-3 ((t (:foreground ,tertiary :weight bold))))
   `(markdown-header-face-4 ((t (:foreground ,primary :weight bold))))
   `(markdown-inline-code-face ((t (:foreground ,primary :background ,surface-container-low :inherit fixed-pitch))))
   `(markdown-code-face ((t (:background ,surface-container-low :extend t :inherit fixed-pitch))))
   `(markdown-pre-face ((t (:background ,surface-container-low :inherit fixed-pitch))))
   `(markdown-table-face ((t (:foreground ,secondary :inherit fixed-pitch))))

   ;; Web mode
   `(web-mode-html-tag-face ((t (:foreground ,secondary))))
   `(web-mode-html-tag-bracket-face ((t (:foreground ,fg-inactive))))
   `(web-mode-html-attr-name-face ((t (:foreground ,secondary))))
   `(web-mode-html-attr-value-face ((t (:foreground ,tertiary))))
   `(web-mode-css-selector-face ((t (:foreground ,primary))))
   `(web-mode-css-property-name-face ((t (:foreground ,secondary))))
   `(web-mode-css-string-face ((t (:foreground ,tertiary))))

   ;; Flycheck
   `(flycheck-error ((t (:underline (:style wave :color ,error)))))
   `(flycheck-warning ((t (:underline (:style wave :color ,tertiary-fixed-dim)))))
   `(flycheck-info ((t (:underline (:style wave :color ,primary)))))
   `(flycheck-fringe-error ((t (:foreground ,error))))
   `(flycheck-fringe-warning ((t (:foreground ,tertiary-fixed-dim))))
   `(flycheck-fringe-info ((t (:foreground ,primary))))

   ;; Mini-buffer customization
   `(minibuffer-prompt ((t (:foreground ,primary :weight bold))))

   ;; Improved search highlighting
   `(lsp-face-highlight-textual ((t (:background ,surface-container-highest :weight bold))))
   `(lsp-face-highlight-read ((t (:background ,surface-container-highest :weight bold))))
   `(lsp-face-highlight-write ((t (:background ,surface-container-highest :weight bold))))

   ;; Info and help modes
   `(info-title-1 ((t (:foreground ,primary :weight bold :height 1.3))))
   `(info-title-2 ((t (:foreground ,secondary :weight bold :height 1.2))))
   `(info-title-3 ((t (:foreground ,tertiary :weight bold :height 1.1))))
   `(info-title-4 ((t (:foreground ,primary :weight bold))))
   `(Info-quoted ((t (:foreground ,primary))))
   `(info-menu-header ((t (:foreground ,primary :weight bold))))
   `(info-menu-star ((t (:foreground ,primary))))
   `(info-node ((t (:foreground ,secondary :weight bold))))

   ;; Tabs
   `(tab-bar ((t (:background ,status-bg :foreground ,fg :box nil))))
   `(tab-bar-tab ((t (:background ,surface-container-high :foreground ,fg :weight bold :box nil))))
   `(tab-bar-tab-inactive ((t (:background ,status-bg :foreground ,fg-inactive :box nil))))

   `(tab-line ((t (:background ,status-bg :foreground ,fg :box nil))))
   `(tab-line-tab ((t (:background ,status-bg :foreground ,fg-inactive :box nil))))
   `(tab-line-tab-current ((t (:background ,surface-container-high :foreground ,fg :weight bold :box nil))))
   `(tab-line-tab-inactive ((t (:background ,status-bg :foreground ,fg-inactive :box nil))))
   `(tab-line-highlight ((t (:background ,surface-container-highest))))

   `(centaur-tabs-default ((t (:background ,status-bg :foreground ,fg))))
   `(centaur-tabs-selected ((t (:background ,surface-container-high :foreground ,fg :weight bold))))
   `(centaur-tabs-unselected ((t (:background ,status-bg :foreground ,fg-inactive))))
   `(centaur-tabs-selected-modified ((t (:background ,surface-container-high :foreground ,primary :weight bold))))
   `(centaur-tabs-unselected-modified ((t (:background ,status-bg :foreground ,primary))))
   `(centaur-tabs-active-bar-face ((t (:background ,primary))))

   ;; Fixed-pitch faces
   `(fixed-pitch ((t (:family "monospace"))))
   `(fixed-pitch-serif ((t (:family "monospace serif"))))

   ;; Variable-pitch face
   `(variable-pitch ((t (:family "sans serif"))))
   ))

;; Add org-mode hooks for hiding leading stars
(with-eval-after-load 'org
  (setq org-hide-leading-stars t)
  (setq org-startup-indented t))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'dankcolors)
;;; dankcolors-theme.el ends here
