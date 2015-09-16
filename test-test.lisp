(load "test")

(format t "TESTING the test framework~&")

(defpackage #:test-test
  (:use #:cl)
  (:use #:test))

(in-package #:test-test)

;;;
;;; BOOTSTRAP TESTS
;;;
(assert (assoc :failure (test::collect-test-results (assert nil))))
(assert (not (assoc :failure (test::collect-test-results (assert t)))))
(assert (equal (assoc :value (test::collect-test-results 'foo)) '(:value . foo)))
(assert (assoc :duration (test::collect-test-results 'foo)))
(assert (assoc :start (test::collect-test-results 'foo)))
(assert (assoc :end (test::collect-test-results 'foo)))
(format t "~A...PASSED~&" 'test::collect-test-results)

;;;
;;; DEFTEST TESTS
;;;
(defmacro assert-no-failure (&body assertion)
  (let ((failure (gensym "fail")))
    `(let ((,failure (assoc :failure (test::collect-test-results
                                       (assert ,@assertion)))))
       (assert (not ,failure) () (format nil "~A" ,failure)))))

(deftest a-simple-failing-test
    "This is a very simple test which fails"
  (assert (= 5 (+ 2 2))))

(let ((test-list (test::test-list)))
  (assert-no-failure (equal test-list '(a-simple-failing-test)))
  (assert-no-failure (fboundp (car test-list)))
  (assert-no-failure (assoc :failure (funcall (car test-list))))
  (assert-no-failure (string= "This is a very simple test which fails"
                              (documentation (car test-list) 'function)))
  (assert-no-failure (equal (assoc :test-name (funcall (car test-list)))
                            '(:test-name . test-test::a-simple-failing-test))))

(deftest a-simple-failing-test
    "This is a very simple test which fails"
  (assert (= 5 (+ 2 2))))

(assert-no-failure (= (length (test::test-list)) 1))

(deftest a-multi-assert-failing-test
    "This test has a second assert which fails"
  (assert (= 2 (+ 1 1)))
  (assert (= 5 (+ 2 2))))

(assert-no-failure (= (length (test::test-list)) 2))

(deftest a-multi-assert-without-docstring-failing-test
  (assert (= 2 (+ 1 1)))
  (assert (= 5 (+ 2 2))))

(assert-no-failure (= (length (test::test-list)) 3))

(deftest a-simple-passing-test
    "This is a very simple test which passes"
  (assert (= 4 (+ 2 2))))

(assert-no-failure (= (length (test::test-list)) 4))

(format t "~A...PASSED~&" 'test:deftest)

(let ((*standard-output* (make-string-output-stream)))
  (run-all-tests)
  (let ((output (get-output-stream-string *standard-output*)))
    (assert-no-failure (search "A-SIMPLE-FAILING-TEST...FAILED." output))
    (assert-no-failure (search "A-MULTI-ASSERT-FAILING-TEST...FAILED." output))
    (assert-no-failure (search "A-MULTI-ASSERT-WITHOUT-DOCSTRING-FAILING-TEST...FAILED." output))
    (assert-no-failure (search "PASSED: 1" output))
    (assert-no-failure (search "FAILED: 3" output))))
(format t "~A...PASSED~&" 'test:run-all-tests)

(load "test")
(assert-no-failure (= 0 (length (test::test-list))))
(format t "Testing Framework...PASSED~&")
