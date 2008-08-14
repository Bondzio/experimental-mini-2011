
;;; flashcard site-lisp configuration 

(add-to-list 'load-path "@SITELISP@")
(add-to-list 'auto-mode-alist '("\\.deck\\'" . flashcard-mode))
(autoload 'flashcard-mode "flashcard" nil t)
(autoload 'flashcard-add-card "flashcard" nil t)
(autoload 'flashcard-import-from-colon-file "flashcard" nil t)
