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

(defvar cangjie-font-lock-keywords
  (list
   ;; Comments
   '("^#!.*" . font-lock-comment-face)
   ;; Variables surrounded with backticks (`)
   '("`[a-zA-Z_][a-zA-Z_0-9]*`" . font-lock-variable-name-face)
   ;; Types
   '("\\b[A-Z][a-zA-Z_0-9]*\\b" . font-lock-type-face)
   ;; Floating point constants
   '("\\b[-+]?[0-9]+\\.[0-9]+\\b" . font-lock-preprocessor-face)
   ;; Integer literals
   '("\\b[-]?[0-9]+\\b" . font-lock-preprocessor-face)
   ;; proper keywords
   `(,(regexp-opt '("as" "break" "Bool" "case" "catch" "case" "catch" "class"
		    "const" "continue" "do" "else" "enum" "extend" "for" "from"
		    "func" "false" "finally" "foreign" "Float16" "Float32"
		    "Float64" "handle" "if" "in" "is" "init" "inout" "import"
		    "interface" "Int8" "Int16" "Int32" "Int64" "IntNative" "let"
		    "mut" "main" "macro" "match" "Nothing" "operator" "perform"
		    "prop" "package" "quote" "resume" "return" "Rune" "spawn"
		    "super" "static" "struct" "synchronized" "try" "this" "true"
		    "type" "throw" "This" "unsafe" "Unit" "UInt8" "UInt16"
		    "UInt32" "UInt64" "UIntNative" "var" "where" "while")
                  'words) . font-lock-keyword-face)
   ;; contextual keywords TODO figure out how to do this properly in emacs
   `(,(regexp-opt '("abstract" "get" "internal" "late" "open" "override"
		    "private" "protected" "public" "redef" "required" "sealed"
		    "set" "throwing" "with")
		  'words) . font-lock-keyword-face)
   ;; Variables
   '("[a-zA-Z_][a-zA-Z_0-9]*" . font-lock-variable-name-face)
   ;; Unnamed variables
   '("$[0-9]+" . font-lock-variable-name-face)
   )
  "Syntax highlighting for CANGJIE"
  )

;; Create mode-specific variables
(defcustom cangjie-basic-offset 4
  "Default indentation width for Cangjie source."
  :type 'integer)

(defun cangjie-indent-line ()
  "Indent the current line according to Cangjie nesting depth."
  (interactive)
  (let (indent-level target-column)
    (save-excursion
      (widen)
      (setq indent-level (car (syntax-ppss (line-beginning-position))))

      ;; Dedent lines that begin with a closing delimiter.
      (beginning-of-line)
      (skip-syntax-forward " ")
      (setq target-column
            (* cangjie-basic-offset
               (- indent-level
                  (if (= (char-syntax (or (char-after) ?\s)) ?\))
                      1
                    0))))
      (indent-line-to (max target-column 0)))
    (when (< (current-column) target-column)
      (move-to-column target-column))))



(define-derived-mode cangjie-mode prog-mode "Cangjie"
  "Major mode for the Cangjie programming language."
  :group 'cangjie
  (setq-local comment-start "// ")
  (setq-local comment-end "")
  (setq-local comment-start-skip "\\(?://+\\|/\\*+\\)\\s *")
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width cangjie-basic-offset)
  (setq-local indent-line-function #'cangjie-indent-line)
  (setq-local electric-indent-chars
              (append '(?\} ?\) ?\]) electric-indent-chars))
  (setq-local font-lock-defaults '(cangjie-font-lock-keywords)))


;;;###autoload
(add-to-list 'auto-mode-alist '("\\.cj\\'" . cangjie-mode))

(provide 'cangjie-mode)
