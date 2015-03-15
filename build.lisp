(defpackage #:build
  (:use #:cl))

(in-package #:build)

(defun default ()
  (test))

(defun test ()
  (dolist (file '("test-test"))
    (load file)))

(time (progn (default) (format t "~%~%OK~%")))
