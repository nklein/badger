
(cl:in-package #:badger)

(interface:define-interface image ()
  (width (img))
  (height (img))
  (channels (img))
  (pixel (img x y c))
  (set-pixel (v img x y c)))
