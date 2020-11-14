
(cl:in-package #:badger)

(hunchentoot:define-easy-handler (show-form :uri "/") ()
  (setf (hunchentoot:content-type*) "text/html")
  (let ((tmpl (find-template "show-form.html")))
    (with-output-to-string (html-template:*default-template-output*)
      (html-template:fill-and-print-template tmpl nil))))
