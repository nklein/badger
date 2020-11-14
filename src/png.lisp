
(cl:in-package #:badger)

(interface:define-implementation png-image (image)
  :width #'png-read:width
  :height #'png-read:height
  :channels (constantly 4)
  :pixel (lambda (img x y z)
           (let* ((ww (png-read:width img))
                  (hh (png-read:height img))
                  (cc 4)
                  (xx (clamp x ww))
                  (yy (clamp y hh))
                  (zz (clamp z cc)))
             (if (and (= x xx) (= y yy) (= z zz))
                 (aref (png-read:image-data img) x y z)
                 0)))
  :set-pixel (lambda (v img x y z)
               (let* ((ww (png-read:width img))
                      (hh (png-read:height img))
                      (cc 4)
                      (xx (clamp x ww))
                      (yy (clamp y hh))
                      (zz (clamp z cc))
                      (vv (clamp v 255)))
                 (if (and (= x xx) (= y yy) (= z zz))
                     (setf (aref (png-read:image-data img) x y z) vv)
                     v))))

(defun png-image-from-file (filename)
  (let ((img (png-read:read-png-file filename)))
    (assert (eql :truecolor-alpha (png-read:colour-type img)))
    img))
