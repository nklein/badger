
(cl:in-package #:badger)

(defun find-template (name)
  (let* ((system (asdf:find-system :badger t))
         (dir (asdf:find-component system "templates"))
         (file (asdf:find-component dir name)))
    (asdf:component-pathname file)))
