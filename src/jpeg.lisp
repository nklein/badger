
(cl:in-package #:badger)

(declaim (inline jpeg-index))
(defun jpeg-index (x y z ww hh cc)
  (declare (ignore hh))
  (+ (* (+ (* y ww)
           x)
        cc)
     (- 2 z)))

(interface:define-implementation jpeg-image (image)
  :width #'second
  :height #'third
  :channels #'fourth
  :pixel (lambda (img x y z)
           (destructuring-bind (pix ww hh cc) img
             (let ((xx (clamp x ww))
                   (yy (clamp y hh))
                   (zz (clamp z cc)))
               (if (and (= x xx) (= y yy) (= z zz))
                   (aref pix (jpeg-index x y z ww hh cc))
                   0))))
  :set-pixel (lambda (v img x y z)
               (destructuring-bind (pix ww hh cc) img
                 (let ((xx (clamp x ww))
                       (yy (clamp y hh))
                       (zz (clamp z cc))
                       (vv (clamp v 255)))
                   (if (and (= x xx) (= y yy) (= z zz))
                       (setf (aref pix (jpeg-index x y z ww hh cc)) vv)
                       vv)))))

(defun jpeg-image-from-file (filename)
  (multiple-value-bind (img hh ww cc) (cl-jpeg:decode-image filename)
    (assert (= cc 3))
    (list img ww hh cc)))

(defun make-jpeg-image (ww hh cc)
  (list (make-array (* ww hh cc)
                    :element-type '(unsigned-byte 8))
        ww
        hh
        cc))

(defun file-from-jpeg-image (img filename)
  (destructuring-bind (pix ww hh cc) img
    (cl-jpeg:encode-image filename pix cc hh ww))
  filename)
