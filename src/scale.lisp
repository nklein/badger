
(cl:in-package #:badger)

(defun nearest-neighbor-scale-down (a-type a factor)
  (let* ((wa (width a-type a))
         (ha (height a-type a))
         (cc (channels a-type a))
         (wb (floor wa factor))
         (hb (floor ha factor))
         (img (make-jpeg-image wb hb cc))
         (off (floor factor 2)))
    (dotimes (yy hb (values img 'jpeg-image))
      (dotimes (xx wb)
        (let* ((xa (+ (* xx factor) off))
               (ya (+ (* yy factor) off)))
          (let ((ra (pixel a-type a xa ya 0))
                (ga (pixel a-type a xa ya 1))
                (ba (pixel a-type a xa ya 2)))
            (set-pixel jpeg-image ra img xx yy 0)
            (set-pixel jpeg-image ga img xx yy 1)
            (set-pixel jpeg-image ba img xx yy 2)))))))

(defun nearest-neighbor-scale-down-and-rotate (a-type a factor)
  (let* ((wa (width a-type a))
         (ha (height a-type a))
         (cc (channels a-type a))
         (wb (floor ha factor))
         (hb (floor wa factor))
         (wb-1 (1- wb))
         (hb-1 (1- hb))
         (img (make-jpeg-image wb hb cc))
         (off (floor factor 2)))
    (dotimes (yy hb (values img 'jpeg-image))
      (dotimes (xx wb)
        (let* ((xa (+ (* yy factor) off))
               (ya (+ (* (- wb-1 xx) factor) off)))
          (let ((ra (pixel a-type a xa ya 0))
                (ga (pixel a-type a xa ya 1))
                (ba (pixel a-type a xa ya 2)))
            (set-pixel jpeg-image ra img xx yy 0)
            (set-pixel jpeg-image ga img xx yy 1)
            (set-pixel jpeg-image ba img xx yy 2)))))))