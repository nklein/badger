
(cl:in-package #:badger)

(defun file-upload-hook (path)
  (format *query-io* "Upload: ~A~%" path))

(setf hunchentoot:*file-upload-hook* #'file-upload-hook)

(defun slurp-file (pathname)
  (with-open-file (in pathname
                      :direction :input
                      :element-type '(unsigned-byte 8))
    (let ((seq (make-array (file-length in)
                           :element-type '(unsigned-byte 8))))
      (read-sequence seq in)
      seq)))

(defun make-image-filename (basename)
  (let ((basename (pathname-name basename)))
    (merge-pathnames (merge-pathnames basename #P"images/*.jpg")
                     (hunchentoot:acceptor-document-root *acceptor*))))

(defun make-overlay-filename (basename)
  (let ((basename (pathname-name basename)))
    (merge-pathnames (merge-pathnames basename #P"overlays/*.png")
                     (hunchentoot:acceptor-document-root *acceptor*))))

(defun calculate-scaling-factor (img-type img ww hh)
  (min (floor (width img-type img) ww)
       (floor (height img-type img) hh)))

(defun calculate-offset-to-center (img-type img xx yy)
  (flet ((offset (length center)
           (- center (ceiling length 2))))
    (list (offset (width img-type img) xx)
          (offset (height img-type img) yy))))

(defun write-badge-to-file (in-path out-path overlay-name cx cy ww hh)
  (let* ((img (jpeg-image-from-file in-path))
         (factor (calculate-scaling-factor jpeg-image img ww hh))
         (img (nearest-neighbor-scale-down-and-rotate jpeg-image img factor))
         (overlay-path (make-overlay-filename overlay-name))
         (overlay (png-image-from-file overlay-path))
         (offsets (calculate-offset-to-center jpeg-image img cx cy))
         (img (blend-images jpeg-image img png-image overlay
                            :x-offset (first offsets)
                            :y-offset (second offsets))))
    (file-from-jpeg-image img out-path)))

(defgeneric write-badge (type in-path out-path))

(defmethod write-badge ((type (eql :umbrella)) in-path out-path)
  (write-badge-to-file in-path out-path "umbrella" 833 510 209 282))

(defmethod write-badge ((type (eql :umbrella-nofingerprint)) in-path out-path)
  (write-badge-to-file in-path out-path
                       "umbrella-nofingerprint"
                       833 510 209 282))

(defmethod write-badge ((type (eql :arkham)) in-path out-path)
  (write-badge-to-file in-path out-path "arkham" 160 245 219 256))

(defmethod write-badge ((type (eql :cdc)) in-path out-path)
  (write-badge-to-file in-path out-path "cdc" 158 394 238 327))

(defun image-file (img-path)
  (make-pathname :name (pathname-name img-path)
                 :type (pathname-type img-path)))


(hunchentoot:define-easy-handler (print-badge :uri "/print-badge")
    (name photo overlay division department)
  (when hunchentoot:*request*
    (setf (hunchentoot:content-type*) "text/html"))
  (let* ((in-path (first photo))
         (out-path (make-image-filename name))
         (tmpl (find-template "print-badge.html")))

    (let ((overlay (intern (string-upcase (or overlay "umbrella"))
                           :keyword)))
      (write-badge overlay in-path out-path))

    (with-output-to-string (html-template:*default-template-output*)
      (html-template:fill-and-print-template tmpl
                                             `(:badge ,(image-file out-path)
                                               :overlay ,overlay
                                               :name ,name
                                               :department ,department
                                               :division ,division)))))
