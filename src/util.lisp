
(cl:in-package #:badger)

(declaim (inline clamp))
(defun clamp (v max)
  (max 0 (min v (1- max))))
