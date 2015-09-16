(defpackage #:datetime
  (:use #:common-lisp)
  (:export #:iso8601))

(in-package #:datetime)

(defun iso8601 (&optional (time (get-universal-time)) (tz 0))
  (multiple-value-bind (second minute hour date month year day daylight-p zone)
      (decode-universal-time time tz)
    (declare (ignore day daylight-p))
    (multiple-value-bind (zone-hours zone-minutes)
        (floor (* (abs zone) 60) 60)
      (format nil "~4,'0D-~2,'0D-~2,'0DT~2,'0D:~2,'0D:~2,'0D~:[~:[+~;-~]~2,'0D~2,'0D~;Z~]"
              year month date hour minute second
              (zerop zone)
              (< zone 0)
              zone-hours
              zone-minutes))))
