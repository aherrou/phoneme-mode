;;; phoneme-mode-el -- Major mode for editing Espeak NG phoneme files

;; Author: Agathe Herrou <agathe@herrou.fr>
;; Created: 27 May 2024
;; Keywords: Espeak phoneme major-mode

;;; Code:
(defvar phoneme-mode-hook nil)

(defvar phoneme-mode-map
  (let ((map (make-keymap)))
    (define-key map "\C-j" 'newline-and-indent)
    (define-key map "\C-x c" 'about-emacs)
    map)
  "Keymap for Phoneme major mode")

(defconst phoneme-font-lock-keywords
  (list
   '("\\<\\(IF\\|ELIF\\|ENDIF\\|ELSE\\|THEN\\|OR\\|CALL\\|AND\\)\\>" . font-lock-builtin-face)
   '("\\<\\(phoneme\\|endphoneme\\|procedure\\|endprocedure\\|PrevVowelEndings\\|NextVowelStarts\\|EndSwitch\\)\\>" . font-lock-keyword-face)
   '("\\<\\(FMT\\|VowelEnding\\|VowelStart\\|nextPh\\|ChangePhoneme\\|nextPhW\\|prevPh\\|prevPhW\\|addWav\\|WAV\\)\\>" . font-lock-constant-face)
   ;; '("\\([[:word:]]+\\)\s*(" 1 font-lock-function-name-face) ;; word followed by an opening parenthesis
'("^procedure[[:space:]]\\(.*\\)" 1 font-lock-function-name-face)
;; '("phoneme[[:space:]]\\([\~\#\/\:\@[:word:]]+\\)" 1 font-lock-function-name-face)
'("^phoneme[[:space:]]\\([[:graph:]]+\\)" 1 font-lock-function-name-face)
   '("\\('\\w*'\\)" . font-lock-variable-name-face))
  "Minimal highlighting expressions for Phoneme mode")

(defun phoneme-indent-line ()
  "Indent current line as Phoneme code"
  (interactive)
  (setq default-tab-width 2)
  (beginning-of-line)
  (if (bobp) ;beginning of buffer
      (indent-line-to 0)
    (let ((not-indented t) cur-indent)
	 (if (looking-at "^[ \t]*\\(end\\|END\\|End\\|ELIF\\)")
	     (progn
	       (save-excursion
		 (forward-line -1)
		 (setq cur-indent (- (current-indentation) default-tab-width)))
	       (if (< cur-indent 0)
		   (setq cur-ident 0)))
	   (save-excursion
	     (while not-indented
	       (forward-line -1)
	       (if (looking-at "^[ \t]*\\(end\\|END\\|End\\)")
		   (progn
		     (setq cur-indent (current-indentation))
		     (setq not-indented nil))
		 (if (looking-at "^[ \t]*\\(phoneme\\|IF\\|PrevVowelEndings\\|NextVowelStarts\\)")
		     (progn
		       (setq cur-indent (+ (current-indentation) default-tab-width))
		       (setq not-indented nil))
		   (if (bobp)
		       (setq not-indented nil)))))))
	 (if cur-indent
	     (indent-line-to cur-indent)
1	   (indent-line-to 0))
	 )))

(defvar phoneme-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?_ "w" st)
    (modify-syntax-entry ?/ ". 12b" st)
    ;; (modify-syntax-entry ?* ". 23" st)
    (modify-syntax-entry ?\n "> b" st)
    st)
  "Syntax table for Phoneme mode")

(defun phoneme-mode ()
  "Major mode for editing phoneme tables for Espeak NG"
  (interactive)
  (kill-all-local-variables)
  (use-local-map phoneme-mode-map)
  (set-syntax-table phoneme-mode-syntax-table)
  (set (make-local-variable 'font-lock-defaults) '(phoneme-font-lock-keywords))
  (set (make-local-variable 'indent-line-function) 'phoneme-indent-line)
  (setq comment-start "//")
  (setq major-mode 'phoneme-mode)
  (setq mode-name "Phoneme")
  (run-hooks 'phoneme-mode-hook))
  
(provide 'phoneme-mode)

;;; phoneme.el ends here
