(defgroup cangjie nil
  "Support for the Cangjie programming language."
  :group 'languages)

(defvar cangjie-mode-syntax-table
  (let ((st (make-syntax-table prog-mode-syntax-table)))
    ;; Cangjie uses C/C++-style line and block comments.
    (modify-syntax-entry ?/ ". 124b" st)
    (modify-syntax-entry ?* ". 23" st)
    (modify-syntax-entry ?\n "> b" st)

    ;; Underscore is part of ordinary identifiers.
    (modify-syntax-entry ?_ "w" st)

    ;; Strings and rune literals can use either quote style. Triple-quoted
    ;; and #-raw strings will need syntax propertization later.
    (modify-syntax-entry ?\" "\"" st)
    (modify-syntax-entry ?' "\"" st)
    st)
  "Syntax table for `cangjie-mode'.")

(define-derived-mode cangjie-mode prog-mode "Cangjie"
  "Major mode for the Cangjie programming language."
  :group 'cangjie
  (setq-local comment-start "// ")
  (setq-local comment-end "")
  (setq-local comment-start-skip "\\(?://+\\|/\\*+\\)\\s *"))


;;;###autoload
(add-to-list 'auto-mode-alist '("\\.cj\\'" . cangjie-mode))

(provide 'cangjie-mode)
