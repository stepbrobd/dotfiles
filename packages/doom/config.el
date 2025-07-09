;;; config.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-nord)

(setq display-line-numbers-type 'visual)
(after! display-line-numbers
  (setq display-line-numbers-current-absolute t))

(use-package! aggressive-indent
  :hook (emacs-lisp-mode . aggressive-indent-mode))
