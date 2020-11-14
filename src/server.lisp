
(cl:in-package #:badger)

;;; 209x282 @ (728,369)
;;; 960x1280 (/4 = 240x320)

(defun start-server (&key
                       (document-root *default-document-root*)
                       (port 4444))
  (unless *acceptor*
    (let ((acptr (make-instance 'hunchentoot:easy-acceptor
                                :document-root document-root
                                :port port)))
      (ensure-directories-exist (merge-pathnames #P"images/" document-root))
      (hunchentoot:start acptr)
      (setf *acceptor* acptr))))

(defun stop-server ()
  (when *acceptor*
    (hunchentoot:stop *acceptor*)
    (setf *acceptor* nil)))
