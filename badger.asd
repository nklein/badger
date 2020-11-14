;;;; badger.asd

(asdf:defsystem #:badger
  :description "Simple web app to make fun badges"
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20171110"
  :license "UNLICENSE"
  :depends-on (#:hunchentoot #:cl-jpeg
                             #:png-read
                             #:html-template
                             #:interface
                             #:asdf)
  ; :in-order-to ((asdf:test-op (asdf:test-op :badger-test)))
  :components
  ((:static-file "README.md")
   (:module "templates"
    :components ((:static-file "show-form.html")
                 (:static-file "print-badge.html")))
   (:module "src"
    :components ((:file "package")
                 (:file "globals" :depends-on ("package"))
                 (:file "util" :depends-on ("package"))
                 (:file "image" :depends-on ("package"))
                 (:file "jpeg" :depends-on ("package"
                                            "image"
                                            "util"))
                 (:file "png" :depends-on ("package"
                                           "image"
                                           "util"))
                 (:file "blend" :depends-on ("package"
                                             "image"))
                 (:file "scale" :depends-on ("package"
                                             "image"))
                 (:file "template" :depends-on ("package"))
                 (:file "show-form" :depends-on ("package"
                                                 "template"))
                 (:file "print-badge" :depends-on ("package"
                                                   "globals"
                                                   "template"
                                                   "jpeg"
                                                   "blend"
                                                   "scale"))
                 (:file "server" :depends-on ("package"
                                              "globals"))))))

#+not
(asdf:defsystem #:badger-test
  :description "Tests for the BADGER package."
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.2.20171110"
  :license "UNLICENSE"
  :depends-on ((:version #:badger "0.2.20171110")
               #:nst)
  :perform (asdf:test-op (o c)
             (uiop:symbol-call :badger-test :run-all-tests))
  :components
  ((:module "test"
    :components ((:file "package")
                 (:file "run" :depends-on ("package"))))))
