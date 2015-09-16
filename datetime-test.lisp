(load "test")
(load "datetime")

(defpackage #:datetime-test
  (:use #:common-lisp #:test))

(in-package #:datetime-test)

(deftest base-case
    (assert (string= (datetime:iso8601 (encode-universal-time 0 0 0 1 1 1970 0))
                     "1970-01-01T00:00:00Z")))

(deftest timezone-cases
    (let ((test-time (encode-universal-time 0 0 0 1 1 1970 0)))
      (assert (string= (datetime:iso8601 test-time 5)
                       "1969-12-31T19:00:00+0500"))
      (assert (string= (datetime:iso8601 test-time -5)
                       "1970-01-01T05:00:00-0500"))
      (assert (string= (datetime:iso8601 test-time (rationalize 8.5))
                       "1969-12-31T15:30:00+0830"))))

(deftest some-other-cases
    (assert
     (string= (datetime:iso8601 (encode-universal-time 1 2 3 4 5 1906 7) 7)
              "1906-05-04T03:02:01+0700"))
  (assert
   (string= (datetime:iso8601 (encode-universal-time 15 39 22 15 9 2015 5) 0)
            "2015-09-16T03:39:15Z")))

(run-all-tests)
