(defpackage #:test
  (:use #:cl)
  (:export #:deftest #:run-all-tests))
(in-package #:test)

(defmacro collect-test-results (&body body)
  (let ((start-time (gensym "test"))
        (end-time (gensym "test"))
        (info (gensym "test")))
    `(let* ((,start-time (get-universal-time))
            (,info (handler-case
                       (acons :value (progn ,@body) (list))
                     (error (e) (acons :failure e (list)))))
            (,end-time (get-universal-time)))

       (pairlis (list :start :end :duration)
                (list ,start-time ,end-time (- ,end-time ,start-time))
                ,info))))

(defparameter *test-list* (list))
(defun test-list () *test-list*)

(defmacro deftest (name &optional (documentation) &body body)
  `(progn (setf (symbol-function ',name)
                #'(lambda ()
                    (acons :test-name ',name
                           (collect-test-results ,@body)))

                (documentation ',name 'function) ,documentation)
          (pushnew ',name *test-list*)))

(defun run-all-tests ()
  (let ((results (copy-alist '((:passed . ()) (:failed . ())))))
    (dolist (test (test-list) results)
      (let ((this-result (funcall test)))
        (if (assoc :failure this-result)
            (progn (push this-result (cdr (assoc :failed results)))
                   (format t "~A...FAILED. ~A~&"
                           test
                           (cdr (assoc :failure this-result))))
            (progn (push this-result (cdr (assoc :passed results)))))))
    (format t "~%~%PASSED: ~D~&FAILED: ~D~&"
            (length (cdr (assoc :passed results)))
            (length (cdr (assoc :failed results))))))
