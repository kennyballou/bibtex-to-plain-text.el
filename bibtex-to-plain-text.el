;;; bibtex-to-plain-text.el

;; Copyright 2012, Nick Van Horn

;; Author: Nick Van Horn <nemo1211@gmail.com>
;; Keywords: bibtex latex citation bibliography

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;; bibtex-to-plain-text.el
;; =======================

;; Tools for quickly creating plain text bibliographic references from
;; BibTeX entries

;; The initial purpose of this package was to enable easy conversion from
;; BibTeX/LaTeX citations into a plain text format that can be easily
;; pasted into other programs that are unfriendly to LaTeX (or for
;; quickly sharing references with colleagues or friends through email,
;; etc.).

;; Currently, this package allows you to easily convert either BibTeX
;; formatted text, or latex \cite{} commands in a buffer into plain text
;; APA formatted references. Of course, formatting such as underlining
;; and italics will be missing from the reference string. As of now, if
;; you plan to paste the formatted string into another program (such as
;; M$ Word), you will need to manually add such markup. Future versions
;; will hopefully remove this necessity.

;; bibtex-to-plain-text is agnostic to the referencing style used as
;; output. The default is APA styling. Styling behavior is controlled by
;; the variable bibtex-to-plain-text-style, which is set by
;; default to an association list called
;; bibtex-to-plain-text-apa-formats that contains the
;; formatting styles for each BibTeX entry type (article, book,
;; incollection, etc.). Additional styles (MLA, Chicago style, etc.) will
;; be added in time. Users can also provide their own custom style rules
;; by creating custom association lists according to those defined in
;; bibtex-to-plain-text.el. By setting
;; bibtex-to-plain-text-style to the custom list, the output
;; behavior of bibtex-to-plain-text can be modified:

;;  (setq bibtex-to-plain-text-style
;; bibtex-to-plain-text-my-custom-format-list) 

;; Setup
;; =====

;; This package requires that bibtex and
;; reftex-cite are installed.

;; Provided bibtex-to-plain-text.el is on your load path, a simple
;; require will get you up and running.

;;  (require 'bibtex-to-plain-text) 

;; To use the latex- commands below, you will need to ensure
;; that your LaTeX/BibTeX installations are set up properly. Most
;; importantly, your .bib file(s) specified in your LaTeX
;; \bibliography{} statements should be on the correct
;; path. This is not a requirement for the bibtex- commands.

;; Usage
;; =====

;; The package makes several functions available. <i>Expect these
;; functions to be renamed soon.</i>

;; bibtex-create-plain-text-reference
;; ----------------------------------

;; This converts a BibTeX entry under point (selecting a region is NOT
;; required) to a plain text reference. The result is pushed to the kill
;; ring. Example:

;; @article{petrov2011,
;;   title =	 {Dissociable perceptual-learning mechanisms revealed
;;                   by diffusion-model analysis},
;;   author =	 {Petrov, A.A. and Van Horn, N.M. and Ratcliff, R.},
;;   journal =	 {Psychonomic bulletin \& review},
;;   volume =	 18,
;;   number =	 3,
;;   pages =	 {490--497},
;;   year =	 2011,
;;   publisher = {Springer}
;; } 

;; Running M-x bibtex-create-plain-text-reference with point
;; anywhere inside the above BibTeX entry will produce the following APA
;; reference:

;;  Petrov, A.A. and Van Horn, N.M. and Ratcliff,
;; R. (2011). Dissociable perceptual-learning mechanisms revealed by
;; diffusion-model analysis. Psychonomic Bulletin & Review, 18(3),
;; 490-497.  

;; bibtex-convert-buffer-to-plain-text
;; -----------------------------------

;; This is a wrapper for bibtex-create-plain-text-reference
;; described above. The current buffer is searched and all BibTeX entries
;; are converted to plain text. The results are written to a buffer named
;; \*references\*. The contents of the current buffer can contain a
;; mixture of BibTeX markup and other text. Thus,
;; bibtex-convert-buffer-to-plain-text will scrape your
;; buffer of any BibTeX entries and convert them into a references list.

;; latex-convert-buffer-to-plain-text
;; ----------------------------------

;; This function should be run inside of a LaTeX document containing one
;; or more \cite{} commands. Provided you have specified a
;; bibliography file in \bibliography{} statement, the
;; function will create a plain text reference list formatted according
;; to the standards associated with the reference type of each citation
;; (e.g., article, book, etc. will be treated uniquely). This should work
;; across multi-file LaTeX documents as well (i.e., those using
;; \input{} statements).

;; latex-create-plain-text-reference
;; ---------------------------------

;; <b>Currently not working properly!!!</b>

;; This function creates a plain text formatted reference of the
;; \cite{} entry under point. The reference is pushed to the
;; kill ring.

;; ##################################################################
;; 
;; The variable bibtex-to-plain-text-style controls the behavior of
;; the interactive function `bibtex-create-plain-text-reference'. The
;; way this works is: Each entry type will be represented by an
;; association list. The key in the alist is the entry type, and the
;; value is a pair of lists. The first item in the pair will consist
;; of a list of the BibTex fields required to format the entry
;; type. The second item will be a formatting string showing how to
;; build the reference in plain text. For example, for APA style
;; formatting of the BibTex entry type 'article', the relevant list
;; would be:
;;
;; ("article" . (("author" "year" "title" "journal" "volume"
;;	           "number" "pages") 
;;	          "%s. (%s). %s. %s, %s%s, %s."))
;;
;; Any conceivable Bibtex type can have a similar list, and these
;; should all be contained in the same association list. The key in
;; each pair will be the BibTex type, and the value will be a list
;; like the one above. Once this is set up the function
;; bibtex-create-plain-text-reference will do the following: 

;; 1 : Determine the type of the Bibtex entry under point 
;; 2 : Consult the association list for the appropriate formatting 
;; 3 : Generate and return the formatted string (and optionally push
;;     the string to the kill ring)

;; Because each entry type in the association list is specified
;; through a formatting string, any notion of style (APA, IEEE, etc.)
;; is hidden from the function. This setup requires some initial work
;; because care must be taken when defining each formatting
;; string. However, this buys the user extra flexibility because even
;; unorthodox styles can be created for specific usages. To support
;; multiple styles, the value of bibtex-to-plain-text-style should be
;; set as an alias to a properly formatted association list containing
;; the formatting lists described above. In principle, the list can
;; have any name. A representative list of APA formatting follows and
;; is used by default. To change this, create your own similar list
;; under a different name, and use 
;;    (setq bibtex-to-plain-text-style your-list-here) 
;; to change the style. 

;; This set of functions requires bibtex and reftex to be loaded
(require 'bibtex)
(require 'reftex-cite)
					 

(setq bibtex-to-plain-text-apa-formats
      '(
	("article" . (("author" "year" "title" "journal" "volume"
		       "number" "pages") 
		      "%s (%s). %s. %s, %s[(%s)], %s."))
	("book" . (("author" "year" "title" "editor" "address"
		    "publisher") 
		   "%s (%s). %s.[ %s] [%s: ]%s."))
	("inproceedings" . (("author" "year" "title" "editor"
			     "booktitle" "pages" "address"
			     "publisher")
	    "%s (%s). %s.[ In %s (Ed.),] %s[ (pp. %s)]. %s: %s."))
	("techreport" . (("author" "year" "title" "number" "address"
			  "institution")
			 "%s (%s). %s[ (%s)]. %s: %s."))))

;; This is what the function bibtex-create-plain-text-reference
;; actually uses. The user can point this to any properly structured
;; association list to change the formatting style, for example from
;; APA to MLA style.
(setq bibtex-to-plain-text-style bibtex-to-plain-text-apa-formats)


;; This function will push a plain text formatted reference to the
;; kill ring based on the current BibTeX entry under point. The
;; purpose of this is for sharing citations with other programs that
;; don't allow me to use LaTeX/BibTeX. Of course, the plain text will
;; need to be formatted manually in the destination application (with
;; italics, etc.). The style and entry types allowable are defined in
;; the association list 
(defun bibtex-create-plain-text-reference (prefixArgCode)
  "Pushes a plain text formatted reference of the current BibTeX
entry to the kill ring. If `universal-argument' is called, the
plain text reference is returned without pushing to the kill
ring. Customize the variable bibtex-to-plain-text-style
to control allowable BibTeX entry types and their corresponding
formatting."
  (interactive "P")
  (save-excursion
    (bibtex-beginning-of-entry)
    (setq myentry (bibtex-parse-entry))
    (setq entry-type (downcase (cdr (assoc "=type=" myentry))))
    (if (member entry-type (mapcar 'car bibtex-to-plain-text-style))
      (progn
	(setq formatted-bibtex-text (format-bibtex-as-plain-text entry-type))
	(when (equal prefixArgCode nil)
	  (kill-new formatted-bibtex-text)
	  (message "Reference pushed to the kill ring"))
	formatted-bibtex-text)
      (message "This BibTeX entry type is not supported!"))))
    

;; This is a helper function that does all the heavy lifting for
;; bibtex-create-plain-text-reference. It takes as input the BibTex
;; entry type and returns the appropriately formatted reference
;; string.
(defun format-bibtex-as-plain-text (entry-type)	   
  "Formats the current BibTeX entry under point according to the
entry-type. Formatting is controlled by the customizable variable
bibtex-to-plain-text-style"
  ;; Find the association values that correspond to the key entry-type
  (setq myEntrySpec (assoc entry-type
			   bibtex-to-plain-text-style)) 
  ;; Isolate the fields that we will be using
  (setq doFields (car (cdr myEntrySpec)))
  ;; Obtain the formatting string
  (setq myFormat (cdr (cdr myEntrySpec)))
  
  ;; This list will store the data from each field as we extract it
  ;; from the entry under point. The contents of this list will be in
  ;; reverse order of how we need them
  (setq entryFields nil)

  ;; Now we work across the fields that we need, grabbing each field's
  ;; data along the way
  (dolist (x doFields) 
    (progn
      ;; Grab the data from the current field, whatever it is
      (setq currData (bibtex-text-in-field x))
      ;; We may need to perform some pre-processing on the text
      (cond
       ((and (equal "pages" x) (not (equal "" currData)))
	(progn
	  (setq currData (when (and (not (equal currData nil))
                                (string-match "--" currData))
			   (replace-match "-" nil nil currData)))))
       ((equal "number" x)
	(progn
	  (if (not (null currData))
	      (setq currData (format "%s" currData)))))
       ((equal "editor" x)
	(progn
	  (if (not (null currData))
	      (setq currData (format "(%s, Eds.)." currData))))))
      ;; Clear out newline characters if present. If the entry is
      ;; missing, then this value is currently nil. In this case,
      ;; convert the nil to the string "###". This enables accurate
      ;; removal of missing entry components downstream via regex
      ;; matching. Also, if one of these missing componants make it
      ;; through the regex replace, it will be visually identifiable
      ;; and can be removed manually.
      (if (not (null currData))
	  (setq currData (mapconcat 'identity 
				    (split-string currData) " "))
	;; Else
	(setq currData "###"))
      ;; Push the captured data onto our list
      (push currData entryFields)))
  ;; Format the resulting list. This involves three steps in this order: 
  ;; (1) Format the citation according to the rules specified in
  ;;     myFormat.
  ;; (2) Remove empty formatting surrounded by "|" characters. This
  ;;     step removes broken citation formatting resulting from
  ;;     missing fields in the BibTeX entry.
  ;; (3) Remove remaining "|" characters and residual BibTex
  ;;     formatting characters, such as "{" and "}". The remaining "|"
  ;;     result from BibTex entries that DO exist in formatting
  ;;     locations wherein they might not have existed.

  ;; Step 1
  (setq raw-citation (apply 'format (mapconcat '(lambda(x) (format "%s" x)) myFormat "")
	 (reverse entryFields)))
  ;; Step 2
  (setq raw-citation (replace-regexp-in-string
  		      "\\[.*?###.*?\\]" ""
  		      raw-citation))
  ;; Step 3
  ;; (replace-regexp-in-string "[|{\\}]" "" raw-citation))
  (let ((finalString raw-citation))
    (dolist (x '("\\[" "\\]" "{" "}" "\\\\")) 
      (setq finalString 
    	    (replace-regexp-in-string x "" finalString)))
    finalString))

;; This is a wrapper function that applies the function
;; bibtex-create-plain-text-reference to the entire buffer. The
;; buffer can contain a mixture of BibTeX entries and other unrelated
;; text. Thus, this function will scrape BibTeX entries embedded in
;; text that isn't entirely BibTeX formatted. The results are
;; formatted to APA format (in plain text, however) and are dumped
;; into the special buffer *references*
(defun bibtex-convert-buffer-to-plain-text ()
  "Convert all bibtex entries in the current buffer to plain text
references. This function finds each BibTeX entry and formats it
using `bibtex-create-plain-text-reference'. Results are pushed
into a new buffer called *references*"
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (with-output-to-temp-buffer "*references*"
      (while (not (eobp))
	(bibtex-skip-to-valid-entry)
	(setq current-formatted-text
	      (bibtex-create-plain-text-reference t))
	(if (not (eobp)) (next-line))
	(princ (concat current-formatted-text "\n\n"))))
    (set-buffer "*references*")
    (fundamental-mode)
    (setq buffer-read-only nil))
  (message "References written to buffer *references*"))

;; **************************************************
;; LaTeX To Plain Text Utilities
;; **************************************************
;; 
;; Functions below this point apply the same logic and functionality
;; as those above. The difference is this: the functions above act on
;; BibTeX entries in a buffer, whereas functions below act on
;; citation markups in LaTeX formatted buffers. Thus, whereas
;; bibtex-create-plain-text-reference creates a single plain text
;; reference based on a BibTeX entry,
;; latex-create-plain-text-reference does the same thing for a
;; \cite{bib-key} occurance. 

(defun latex-convert-buffer-to-plain-text ()
  "Convert all LaTeX-formatted citation markups in the current
buffer to plain text references. This function finds each
citation entry and formats it into a plain text
reference. Results are pushed into a new buffer called
*references*"
  (interactive)
  (save-excursion
    ;; Extract all citations and write their corresponding BibTeX
    ;; entries to a temporary buffer
    (latex-create-bibtex-buffer)
    ;; Change to the newly created buffer and utilize the bibtex-
    ;; functions above
    (setq bib-buffer-name "*bibEntries*")
    (set-buffer bib-buffer-name)
    (bibtex-convert-buffer-to-plain-text)
    (kill-buffer bib-buffer-name)))

(defun latex-create-bibtex-buffer ()
  "Create a new BibTeX database buffer with all entries
  referenced in document.  Only entries referenced in the current
  document with any \\cite-like macros are used.  The sequence in
  the new buffer is the same as it was in the old database. Note that
  this functions like reftex-create-bibtex-file with the notable
  difference that results are inserted into a buffer rather than a new
  file."
  (interactive)
  (let ((keys (reftex-all-used-citation-keys))
        (files (reftex-get-bibfile-list))
        file key entries beg end entry)
    ;; We want to work in a temporary buffer
    (setq bib-buffer-name "*bibEntries*")

    (while (setq file (pop files))
      (set-buffer (reftex-get-file-buffer-force file 'mark))
      (reftex-with-special-syntax-for-bib
       (save-excursion
	 (save-restriction
	   (widen)
	   (goto-char (point-min))
	   (while (re-search-forward "^[ \t]*@\\(?:\\w\\|\\s_\\)+[ \t\n\r]*\
\[{(][ \t\n\r]*\\([^ \t\n\r,]+\\)" nil t)
	     (setq key (match-string 1)
		   beg (match-beginning 0)
		   end (progn
			 (goto-char (match-beginning 1))
			 (condition-case nil
			     (up-list 1)
			   (error (goto-char (match-end 0))))
			 (point)))
	     (when (member key keys)
	       (setq entry (buffer-substring beg end)
		     entries (cons entry entries)
		     keys (delete key keys))))))))
    ;; (find-file-other-window bibfile)
    ;; (switch-to-buffer bib-buffer-name)
    (switch-to-buffer bib-buffer-name)
    (bibtex-mode)
    (insert (mapconcat 'identity (reverse entries) "\n\n"))
    (goto-char (point-min))
    (message "%d entries extracted and copied to %s"
	     (length entries) bib-buffer-name)))


(provide 'bibtex-to-plain-text)
