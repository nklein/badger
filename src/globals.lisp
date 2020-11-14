
(cl:in-package #:badger)

(defvar *acceptor* nil)
(defvar *default-document-root*
  (merge-pathnames #P"www/"
                   (asdf:component-pathname (asdf:find-system :badger))))
