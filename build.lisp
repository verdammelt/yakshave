(defpackage #:build
  (:use #:cl))

(in-package #:build)

(defun default ()
  (test))

(defun test ()
  (dolist (file (directory "*-test.lisp"))
    (load file :verbose t)))

(time (progn (default) (format t "~%~%OK~%~%")))
