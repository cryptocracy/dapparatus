;; Implement the `ft-trait` trait defined in the `ft-trait` contract
(impl-trait 'ST1ZG09W7XN7S1WH5F06YN25C5CGK2RE01D6CSA1H.ft-trait.ft-trait)

(define-fungible-token luv-token u21000000000000)
(define-constant err-unauthorized u1)

;; Mint Tokens
(define-constant minter 'ST1ZG09W7XN7S1WH5F06YN25C5CGK2RE01D6CSA1H)
(ft-mint? luv-token u21000000000000 minter)

(define-read-only (get-total-supply)
  (ok (ft-get-supply luv-token))
)

(define-read-only (get-name)
  (ok "Luv Token")
)

(define-read-only (get-symbol)
  (ok "LUV")
)

(define-read-only (get-decimals)
  (ok u0)
)

(define-read-only (get-balance (account principal))
  (ok (ft-get-balance luv-token account))
)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (if (is-eq tx-sender sender)
    (begin
      (try! (ft-transfer? luv-token amount sender recipient))
      (print memo)
      (ok true)
    )
   (err u4)))

(define-read-only (get-token-uri)
  (ok (some u"https://cryptocracy.io/assets/luv.json"))
)