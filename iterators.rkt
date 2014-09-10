#lang racket

(define mapp
  (lambda (f col)
    (cond
      ((null? col) '())
      (else
       (cons (f (car col))
             (mapp f (cdr col)))))))


(define fold
  (lambda (acc col fun)
    (cond
      ((null? col) acc)
      (else
       (fold (fun (car col) acc)
             (cdr col)
             fun)))))

;(fold 0 '(1 2 3) (lambda (e acc)(+ e acc)))
;(fold 1 '(1 2 3) (lambda (e acc)(* e acc)))
;(fold '() '(n m s) (lambda (e acc) (cons (cons e '()) acc)))

(define filter
  (lambda (l f)
    (cond
      ((null? l) '())
      ((f (car l))
       (cons (car l)
             (filter (cdr l) f)))
      (else
       (filter (cdr l) f)))))

;(filter '(1 2 3 4 5) (lambda (n) (> n 3)))

(define sum
  (lambda (l)
    (cond
      ((null? l) 0)
      (else
       (+ (car l)
          (sum (cdr l)))))))

;(sum '(1 2 3))

(define product
  (lambda (l)
    (cond
      ((null? l) 1)
      (else
       (* (car l)
          (product (cdr l)))))))

; (product '(1 2 3))

;(mapp (lambda (e) (* 2 e))'(1 2 3))
